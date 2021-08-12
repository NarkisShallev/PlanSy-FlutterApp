import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/build_google_maps_icon.dart';
import 'package:plansy_flutter_app/components/buttons/approve_or_reject_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_add_to_trip_dialog.dart';
import 'package:plansy_flutter_app/components/build_big_attraction_image.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/add_to_trip_button.dart';
import 'package:plansy_flutter_app/components/cards/attraction_details_card.dart';
import 'package:plansy_flutter_app/components/my_divider.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/star_rating_with_num_of_reviews.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_show_address.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/attractions/update_attraction_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class AttractionDetailsScreen extends StatefulWidget {
  final attractionIndex;
  final Attraction attraction;
  final bool isAddToCartButtonVisible;
  final bool isAdmin;
  final bool isApproveOrRejectButtonVisible;
  final bool isFavorite;

  const AttractionDetailsScreen({
    @required this.attractionIndex,
    @required this.attraction,
    @required this.isAddToCartButtonVisible,
    @required this.isAdmin,
    @required this.isApproveOrRejectButtonVisible,
    @required this.isFavorite,
  });

  @override
  _AttractionDetailsScreenState createState() => _AttractionDetailsScreenState();
}

class _AttractionDetailsScreenState extends State<AttractionDetailsScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool isFavoritePressed = false;
  String newName;
  String newCategory;
  String newLocation;
  String newCity;
  String newDescription;
  String newOpeningTime;
  String newClosingTime;
  String newWebSite;
  String newPricing;
  String newIsNeedToBuyTickets;
  String newSuitableFor;
  String newSuitableSeason;
  String newDuration;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildAttractionDetailsContent(context),
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
    final imageFile = await screenshotController.capture();
    Share.shareFiles([imageFile.path]);
  }

  Visibility buildBottomNavigationBar() => Visibility(
        visible: !widget.isAdmin,
        child: PrimaryBottomNavigationBar(
            isHome: false, isBrowse: false, isWishList: false, isCart: false),
      );

  Column buildAttractionDetailsContent(BuildContext context) => Column(
        children: [
          Screenshot(controller: screenshotController, child: buildScreenshotContent()),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildAddToTripButton(),
          buildApproveOrRejectButton(),
          SizedBox(height: getProportionateScreenHeight(15)),
        ],
      );

  Column buildScreenshotContent() => Column(
        children: [
          buildBigAttractionImage(attraction: widget.attraction),
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
            buildFavorite(),
          ],
        ),
      );

  InkWell buildLocationIcon() => buildGoogleMapsIcon(onTap: () => openGoogleMaps());

  void openGoogleMaps() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleMapsShowAddress(
            latLngLocation: widget.attraction.latLngLocation,
            name: widget.attraction.name,
            address: widget.attraction.address,
          ),
        ),
      );

  Expanded buildAddressText() => Expanded(
        flex: 5,
        child:
            Text(widget.attraction.address, style: k13BlackStyle, overflow: TextOverflow.ellipsis),
      );

  Visibility buildFavorite() => Visibility(
        visible: widget.isFavorite,
        child: Expanded(
          child: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: changeColorFavoriteWhenPress,
            color: Provider.of<Data>(context, listen: false).wishListContains(widget.attraction)
                ? Colors.red
                : kSecondaryColor,
            iconSize: getProportionateScreenWidth(30),
          ),
        ),
      );

  void changeColorFavoriteWhenPress() {
    int tripId = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripId];
    bool isPressed = Provider.of<Data>(context, listen: false).wishListContains(widget.attraction);
    setState(() {
      isFavoritePressed = !isFavoritePressed;
      if (isPressed) {
        Provider.of<Data>(context, listen: false)
            .deleteAttractionFromWishList(widget.attraction, context, trip.getID());
      } else {
        Provider.of<Data>(context, listen: false)
            .addAttractionToWishList(widget.attraction, context, trip.getID());
      }
    });
  }

  Column buildDetailsText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          MyDivider(),
          BuildCategory(attraction: widget.attraction),
          MyDivider(),
          BuildDescription(attraction: widget.attraction),
          MyDivider(),
          BuildOpeningTime(attraction: widget.attraction),
          MyDivider(),
          BuildWebSite(attraction: widget.attraction),
          MyDivider(),
          BuildPricing(attraction: widget.attraction),
          MyDivider(),
          buildIsNeedToBuyTickets(),
          MyDivider(),
          BuildSuitableFor(attraction: widget.attraction),
          MyDivider(),
          BuildSuitableSeason(attraction: widget.attraction),
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
                SizedBox(width: getProportionateScreenWidth(2)),
                Visibility(
                  visible: widget.attractionIndex != null,
                  child: buildEditIconButton(),
                ),
              ],
            ),
            buildStars(),
          ],
        ),
        height: getProportionateScreenHeight(110),
      );

  Text buildAttractionName() =>
      Text(widget.attraction.name, style: k18BlackStyle, overflow: TextOverflow.ellipsis);

  IconButton buildEditIconButton() =>
      IconButton(icon: Icon(Icons.edit), onPressed: () => moveToUpdateAttractionScreen());

  StarRatingWithNumOfReviews buildStars() => StarRatingWithNumOfReviews(
        numOfReviews: int.parse(widget.attraction.numOfReviews),
        rating: double.parse(widget.attraction.rating),
        starsSize: getProportionateScreenWidth(20),
        alignment: MainAxisAlignment.start,
        isReadOnly: widget.isAdmin ? true : false,
        onRated: (double rate) => updateNumOfReviewsAndRate(rate),
      );

  void updateNumOfReviewsAndRate(double rate) {
    Map<String, dynamic> changes = {}; // map between field and change, e.g: "location", "value".

    // get existing values
    int numOfReviewsInt = int.parse(widget.attraction.numOfReviews);
    double ratingDouble = double.parse(widget.attraction.rating);

    // compute new values
    double total = numOfReviewsInt * ratingDouble;
    int newNumOfReviewsInt = (numOfReviewsInt + 1);
    String newNumOfReviews = newNumOfReviewsInt.toString();
    String newRating = ((total + rate) / newNumOfReviewsInt).toString();

    // update
    changes["NumOfReviews"] = newNumOfReviews;
    changes["Rating"] = newRating;
    createUpdatedNumOfReviewsAndRatingAttraction(newNumOfReviews, newRating);
    FireBaseSingleton().changeAttraction(widget.attraction.getID(), changes);
  }

  Attraction createUpdatedNumOfReviewsAndRatingAttraction(
      String newNumOfReviews, String newRating) {
    Attraction updated = Attraction(
        status: 2,
        category: widget.attraction.category,
        address: widget.attraction.address,
        latLngLocation: widget.attraction.latLngLocation,
        openingTime: widget.attraction.openingTime,
        closingTime: widget.attraction.closingTime,
        numOfReviews: newNumOfReviews,
        description: widget.attraction.description,
        country: widget.attraction.country,
        duration: widget.attraction.duration,
        isNeedToBuyTickets: widget.attraction.isNeedToBuyTickets,
        suitableFor: widget.attraction.suitableFor,
        suitableSeason: widget.attraction.suitableSeason,
        recommendations: widget.attraction.recommendations,
        pricing: widget.attraction.pricing,
        imageSrc: widget.attraction.imageSrc,
        name: widget.attraction.name,
        webSite: widget.attraction.webSite,
        rating: newRating,
        priority: 0);
    updated.setID(widget.attraction.getID());
    return updated;
  }

  AttractionDetailsCard buildIsNeedToBuyTickets() => AttractionDetailsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need to buy tickets?  ", style: k13GreenStyle),
            Expanded(child: Text(widget.attraction.isNeedToBuyTickets, style: k13BlackStyle)),
          ],
        ),
        height: getProportionateScreenHeight(40),
      );

  AttractionDetailsCard buildDuration() => AttractionDetailsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Duration:  ", style: k13GreenStyle),
            Expanded(
              child: Text(
                TimeOfDayExtension(widget.attraction.duration).str(),
                style: k13BlackStyle,
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

  void addToCartWhenPress() {
    bool isPressed = Provider.of<Data>(context, listen: false).cartContains(widget.attraction);
    setState(() {
      if (!isPressed) {
        int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
        Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
        Provider.of<Data>(context, listen: false)
            .addAttractionToCart(widget.attraction, context, trip.getID());
        showAddToTripDialog(context, false);
      } else {
        showAddToTripDialog(context, true);
      }
    });
  }

  Visibility buildApproveOrRejectButton() {
    Request req =
        Provider.of<Data>(context, listen: false).getRequestFromAttraction(widget.attraction);
    return Visibility(
      visible: widget.isApproveOrRejectButtonVisible,
      child: ApproveOrRejectButton(request: req),
    );
  }

  void moveToUpdateAttractionScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateAttractionScreen(
            attractionIndex: widget.attractionIndex,
            isAdmin: widget.isAdmin,
            isApproveOrRejectButtonVisible: false,
          ),
        ),
      );
}

class BuildCategory extends StatefulWidget {
  final Attraction attraction;

  const BuildCategory({@required this.attraction});

  @override
  State<BuildCategory> createState() => _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category:  ", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.category,
              style: k13BlackStyle,
              trimLines: 1,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight((widget.attraction.category.length * 1.15).toDouble())
          : getProportionateScreenHeight(60),
    );
  }
}

class BuildDescription extends StatefulWidget {
  final Attraction attraction;

  const BuildDescription({@required this.attraction});

  @override
  State<BuildDescription> createState() => _BuildDescriptionState();
}

class _BuildDescriptionState extends State<BuildDescription> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.description,
              style: k13BlackStyle,
              trimLines: 3,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight((widget.attraction.description.length * 1.15).toDouble())
          : getProportionateScreenHeight(110),
    );
  }
}

class BuildOpeningTime extends StatefulWidget {
  final Attraction attraction;

  const BuildOpeningTime({@required this.attraction});

  @override
  State<BuildOpeningTime> createState() => _BuildOpeningTimeState();
}

class _BuildOpeningTimeState extends State<BuildOpeningTime> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Opening time:  ", style: k13GreenStyle),
          ReadMoreText(
            TimeOfDayExtension(widget.attraction.openingTime).str() +
                "-" +
                TimeOfDayExtension(widget.attraction.closingTime).str(),
            style: k13BlackStyle,
            trimLines: 1,
            colorClickableText: kPrimaryColor,
            trimMode: TrimMode.Line,
            callback: (bool val) {
              if (val == false) {
                setState(() => isReadMorePress = true);
              } else {
                setState(() => isReadMorePress = false);
              }
            },
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight(((TimeOfDayExtension(widget.attraction.openingTime).str() +
                          "-" +
                          TimeOfDayExtension(widget.attraction.closingTime).str())
                      .length *
                  1.15)
              .toDouble())
          : getProportionateScreenHeight(66),
    );
  }
}

class BuildWebSite extends StatefulWidget {
  final Attraction attraction;

  const BuildWebSite({@required this.attraction});

  @override
  State<BuildWebSite> createState() => _BuildWebSiteState();
}

class _BuildWebSiteState extends State<BuildWebSite> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Web-site:  ", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.webSite,
              style: k13BlackStyle,
              trimLines: 1,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight((widget.attraction.webSite.length * 1.15).toDouble())
          : getProportionateScreenHeight(60),
    );
  }
}

class BuildPricing extends StatefulWidget {
  final Attraction attraction;

  const BuildPricing({@required this.attraction});

  @override
  State<BuildPricing> createState() => _BuildPricingState();
}

class _BuildPricingState extends State<BuildPricing> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing:  ", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.pricing,
              style: k13BlackStyle,
              trimLines: 1,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight((widget.attraction.pricing.length * 2.5).toDouble())
          : getProportionateScreenHeight(60),
    );
  }
}

class BuildSuitableFor extends StatefulWidget {
  final Attraction attraction;

  const BuildSuitableFor({@required this.attraction});

  @override
  State<BuildSuitableFor> createState() => _BuildSuitableForState();
}

class _BuildSuitableForState extends State<BuildSuitableFor> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable for:  ", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.suitableFor,
              style: k13BlackStyle,
              trimLines: 1,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight((widget.attraction.suitableFor.length * 1.15).toDouble())
          : getProportionateScreenHeight(60),
    );
  }
}

class BuildSuitableSeason extends StatefulWidget {
  final Attraction attraction;

  const BuildSuitableSeason({@required this.attraction});

  @override
  State<BuildSuitableSeason> createState() => _BuildSuitableSeasonState();
}

class _BuildSuitableSeasonState extends State<BuildSuitableSeason> {
  bool isReadMorePress = false;

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable season:  ", style: k13GreenStyle),
          Expanded(
            child: ReadMoreText(
              widget.attraction.suitableSeason,
              style: k13BlackStyle,
              trimLines: 1,
              colorClickableText: kPrimaryColor,
              trimMode: TrimMode.Line,
              callback: (bool val) {
                if (val == false) {
                  setState(() => isReadMorePress = true);
                } else {
                  setState(() => isReadMorePress = false);
                }
              },
            ),
          ),
        ],
      ),
      height: isReadMorePress
          ? getProportionateScreenHeight(
              (widget.attraction.suitableSeason.length * 1.15).toDouble())
          : getProportionateScreenHeight(60),
    );
  }
}
