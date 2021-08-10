import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/build_big_attraction_image.dart';
import 'package:plansy_flutter_app/components/build_google_maps_icon.dart';
import 'package:plansy_flutter_app/components/buttons/approve_or_reject_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_add_to_trip_dialog.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_show_address.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/components/buttons/add_to_trip_button.dart';
import 'package:plansy_flutter_app/components/cards/attraction_details_card.dart';
import 'package:plansy_flutter_app/components/my_divider.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/star_rating_with_num_of_reviews.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class UpdateAttractionDetailsScreen extends StatefulWidget {
  final Request request;
  final bool isAddToCartButtonVisible;
  final bool isAdmin;
  final bool isApproveOrRejectButtonVisible;
  final ScreenshotController screenshotController = ScreenshotController();

  UpdateAttractionDetailsScreen({
    @required this.request,
    @required this.isAddToCartButtonVisible,
    @required this.isAdmin,
    @required this.isApproveOrRejectButtonVisible,
  });

  @override
  _UpdateAttractionDetailsScreenState createState() => _UpdateAttractionDetailsScreenState();
}

class _UpdateAttractionDetailsScreenState extends State<UpdateAttractionDetailsScreen> {
  bool isFavoritePressed = false;
  Request request;
  bool isEdit = false;
  String newName;
  String newCategory;
  String newLocation;
  String newCity;
  String newDescription;
  String newOpeningTime;
  String newClosingTime;
  String newWebSite;
  String newPayment;
  String newIsNeedToBuyTicketsInAdvance;
  String newSuitableFor;
  String newSuitableWeather;
  String newDuration;
  Attraction original;

  void initState() {
    super.initState();
    request = widget.request;
    original = getOriginalAttraction(context);
  }

  void addToCartWhenPress() {
    bool isPressed = Provider.of<Data>(context, listen: false).cartContains(request.updatedAttraction);
    setState(() {
      if (!isPressed) {
        int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
        Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
        Provider.of<Data>(context, listen: false)
            .addAttractionToCart(request.updatedAttraction, context, trip.getID());
        showAddToTripDialog(context, false);
      } else {
        showAddToTripDialog(context, true);
      }
    });
  }

  Attraction getOriginalAttraction(BuildContext context) =>
      Provider.of<Data>(context, listen: false).getAttractionByID(request.originalAttractionIdInFireBase);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildUpdateAttractionDetailsScreenContent(),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) => myAppBar(
        context: context,
        isArrowBack: true,
        isNotification: true,
        isEdit: false,
        isSave: false,
        isTabBar: false,
        isShare: true,
        shareOnPressed: () => takeScreenshot(),
        titleText: '',
        iconsColor: Colors.black,
      );

  void takeScreenshot() async {
    final imageFile = await widget.screenshotController.capture();
    Share.shareFiles([imageFile.path]);
  }

  Visibility buildBottomNavigationBar() => Visibility(
        visible: !widget.isAdmin,
        child: PrimaryBottomNavigationBar(
            isHome: false, isBrowse: false, isWishList: false, isCart: false),
      );

  Column buildUpdateAttractionDetailsScreenContent() => Column(
        children: [
          Screenshot(controller: widget.screenshotController, child: buildScreenshotContent()),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildAddToTripButton(),
          buildApproveOrRejectButton(),
          SizedBox(height: getProportionateScreenHeight(15)),
        ],
      );

  Column buildScreenshotContent() => Column(
        children: [
          buildBigAttractionImage(attraction: widget.request.updatedAttraction),
          buildDetails(),
        ],
      );

  Container buildDetails() => Container(
        color: Colors.blueGrey[50],
        padding: EdgeInsets.all(getProportionateScreenWidth(15)),
        width: double.infinity,
        child: Column(
          children: [
            buildLocationAndFavoriteIcons(),
            buildDetailsText(),
          ],
        ),
      );

  AttractionDetailsCard buildLocationAndFavoriteIcons() => AttractionDetailsCard(
        child: Row(
          children: [
            buildLocationIcon(),
            SizedBox(width: getProportionateScreenWidth(5)),
            buildAddressText(),
            Expanded(child: SizedBox(width: getProportionateScreenWidth(10))),
            buildFavorite()
          ],
        ),
      );

  InkWell buildLocationIcon() => buildGoogleMapsIcon(onTap: () => openGoogleMaps());

  void openGoogleMaps() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleMapsShowAddress(
            latLngLocation: widget.request.updatedAttraction.latLngLocation,
            name: widget.request.updatedAttraction.name,
            address: widget.request.updatedAttraction.address,
          ),
        ),
      );

  Expanded buildAddressText() => Expanded(
        flex: 5,
        child:
            Text(request.updatedAttraction.address, style: k13BlackStyle, overflow: TextOverflow.ellipsis),
      );

  Visibility buildFavorite() => Visibility(
        visible: !widget.isAdmin,
        child: Expanded(
          child: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => changeColorFavoriteWhenPress(),
            color: Provider.of<Data>(context, listen: false)
                    .wishListContains(widget.request.updatedAttraction)
                ? Colors.red
                : kSecondaryColor,
            iconSize: getProportionateScreenWidth(30),
          ),
        ),
      );

  void changeColorFavoriteWhenPress() {
    int tripId = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripId];
    bool isPressed = Provider.of<Data>(context, listen: false).wishListContains(request.updatedAttraction);
    setState(() {
      isFavoritePressed = !isFavoritePressed;
      if (isPressed) {
        Provider.of<Data>(context, listen: false)
            .deleteAttractionFromWishList(request.updatedAttraction, context, trip.getID());
      } else {
        Provider.of<Data>(context, listen: false)
            .addAttractionToWishList(request.updatedAttraction, context, trip.getID());
      }
    });
  }

  Column buildDetailsText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          MyDivider(),
          BuildCategory(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          BuildDescription(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          buildOpeningAndClosingTime(),
          MyDivider(),
          BuildWebSite(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          BuildPricing(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          buildIsNeedToBuyTickets(),
          MyDivider(),
          BuildSuitableFor(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          BuildSuitableWeather(attraction: request.updatedAttraction, original: original),
          MyDivider(),
          buildDuration(),
          MyDivider(),
        ],
      );

  AttractionDetailsCard buildTitle() => AttractionDetailsCard(
        child: Column(
          children: [
            Row(
              children: [
                buildAttractionName(),
              ],
            ),
            buildStars(),
          ],
        ),
        height: getProportionateScreenHeight(90),
      );

  Expanded buildAttractionName() => Expanded(
      child: Text(request.updatedAttraction.name, style: k18BlackStyle, overflow: TextOverflow.ellipsis));

  StarRatingWithNumOfReviews buildStars() => StarRatingWithNumOfReviews(
        numOfReviews: int.parse(request.updatedAttraction.numOfReviews),
        rating: double.parse(request.updatedAttraction.rating),
        starsSize: getProportionateScreenWidth(20),
        alignment: MainAxisAlignment.start,
        isReadOnly: true,
      );

  AttractionDetailsCard buildOpeningAndClosingTime() => AttractionDetailsCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Opening time:  ", style: k13GreenStyle),
            Text(
              TimeOfDayExtension(original.openingTime).str() +
                  "-" +
                  TimeOfDayExtension(original.closingTime).str(),
              style: k13BlackStyle,
            ),
            Expanded(
              child: Visibility(
                visible: (request.updatedAttraction.openingTime != original.openingTime) ||
                    (request.updatedAttraction.closingTime != original.closingTime),
                child: Row(
                  children: [
                    Text(" To: ", style: k13RedStyle),
                    Text(
                      TimeOfDayExtension(request.updatedAttraction.openingTime).str() +
                          "-" +
                          TimeOfDayExtension(request.updatedAttraction.closingTime).str(),
                      style: k13BlackStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        height: getProportionateScreenHeight(40),
      );

  AttractionDetailsCard buildIsNeedToBuyTickets() => AttractionDetailsCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need to buy tickets? ", style: k13GreenStyle),
            Text(original.isNeedToBuyTickets, style: k13BlackStyle),
            Expanded(
              child: Visibility(
                visible: request.updatedAttraction.isNeedToBuyTickets != original.isNeedToBuyTickets,
                child: Row(
                  children: [
                    Text(" To: ", style: k13RedStyle),
                    Text(request.updatedAttraction.isNeedToBuyTickets, style: k13BlackStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
        height: getProportionateScreenHeight(40),
      );

  AttractionDetailsCard buildDuration() => AttractionDetailsCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration:  ", style: k13GreenStyle),
            Text(TimeOfDayExtension(original.duration).str(), style: k13BlackStyle),
            Expanded(
              child: Visibility(
                visible: request.updatedAttraction.duration != original.duration,
                child: Row(
                  children: [
                    Text(" To: ", style: k13RedStyle),
                    Text(
                      TimeOfDayExtension(request.updatedAttraction.duration).str(),
                      style: k13BlackStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        height: getProportionateScreenHeight(40),
      );

  Visibility buildAddToTripButton() => Visibility(
        visible: widget.isAddToCartButtonVisible,
        child: AddToTripButton(press: () => addToCartWhenPress()),
      );

  Visibility buildApproveOrRejectButton() => Visibility(
      visible: widget.isApproveOrRejectButtonVisible,
      child: ApproveOrRejectButton(
        request: request,
        original: getOriginalAttraction(context),
      ));
}

class BuildCategory extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildCategory({@required this.attraction, this.original});

  @override
  State<BuildCategory> createState() => _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category:  ", style: k13GreenStyle),
          ReadMoreText(
            widget.original.category,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.category != widget.original.category,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.category,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.category.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildDescription extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildDescription({@required this.attraction, @required this.original});

  @override
  State<BuildDescription> createState() => _BuildDescriptionState();
}

class _BuildDescriptionState extends State<BuildDescription> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: k13GreenStyle),
          ReadMoreText(
            widget.original.description,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.description != widget.original.description,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.description,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.description.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildWebSite extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildWebSite({@required this.attraction, @required this.original});

  @override
  State<BuildWebSite> createState() => _BuildWebSiteState();
}

class _BuildWebSiteState extends State<BuildWebSite> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Web-site:  ", style: k13GreenStyle),
          ReadMoreText(
            widget.original.webSite,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.webSite != widget.original.webSite,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.webSite,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.webSite.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildPricing extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildPricing({@required this.attraction, @required this.original});

  @override
  State<BuildPricing> createState() => _BuildPricingState();
}

class _BuildPricingState extends State<BuildPricing> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing:  ", style: k13GreenStyle),
          ReadMoreText(
            widget.original.pricing,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.pricing != widget.original.pricing,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.pricing,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.pricing.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildSuitableFor extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildSuitableFor({@required this.attraction, @required this.original});

  @override
  State<BuildSuitableFor> createState() => _BuildSuitableForState();
}

class _BuildSuitableForState extends State<BuildSuitableFor> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable for:  ", style: k13GreenStyle),
          ReadMoreText(
            widget.original.suitableFor,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.suitableFor != widget.original.suitableFor,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.suitableFor,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.suitableFor.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildSuitableWeather extends StatefulWidget {
  final Attraction attraction;
  final Attraction original;

  const BuildSuitableWeather({@required this.attraction, @required this.original});

  @override
  State<BuildSuitableWeather> createState() => _BuildSuitableWeatherState();
}

class _BuildSuitableWeatherState extends State<BuildSuitableWeather> {
  bool isFirstReadMorePress = false;
  bool isSecondReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable weather:  ", style: k13GreenStyle),
          ReadMoreText(
            widget.original.suitableSeason,
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isFirstReadMorePress = true);
              } else {
                setState(() => isFirstReadMorePress = false);
              }
            },
          ),
          Expanded(
            child: Visibility(
              visible: widget.attraction.suitableSeason != widget.original.suitableSeason,
              child: Column(
                children: [
                  Text(" To: ", style: k13RedStyle),
                  ReadMoreText(
                    widget.attraction.suitableSeason,
                    style: k13BlackStyle,
                    trimLines: 1,
                    colorClickableText: kPrimaryColor,
                    trimMode: TrimMode.Line,
                    callback: (bool val) {
                      if (val == false) {
                        setState(() => isSecondReadMorePress = true);
                      } else {
                        setState(() => isSecondReadMorePress = false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      height: isFirstReadMorePress || isSecondReadMorePress
          ? getProportionateScreenHeight((widget.attraction.suitableSeason.length * 2.3).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}
