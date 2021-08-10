import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/approve_or_reject_button.dart';
import 'package:plansy_flutter_app/components/cards/attraction_details_card.dart';
import 'package:plansy_flutter_app/components/dialogs/show_send_to_confirm_dialog.dart';
import 'package:plansy_flutter_app/components/fields/input/build_category_field.dart';
import 'package:plansy_flutter_app/components/build_big_attraction_image.dart';
import 'package:plansy_flutter_app/components/fields/input/build_closing_time_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_description_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_duration_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_is_need_to_buy_tickets_in_advance_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_opening_time_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_pricing_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_suitable_for_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_suitable_season_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_web_site_text_form_field.dart';
import 'package:plansy_flutter_app/components/my_divider.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/star_rating_with_num_of_reviews.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class UpdateAttractionScreen extends StatefulWidget {
  final attractionIndex;
  final bool isAdmin;
  final bool isApproveOrRejectButtonVisible;

  UpdateAttractionScreen({
    @required this.attractionIndex,
    @required this.isAdmin,
    @required this.isApproveOrRejectButtonVisible,
  });

  @override
  _UpdateAttractionScreenState createState() => _UpdateAttractionScreenState();
}

class _UpdateAttractionScreenState extends State<UpdateAttractionScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  Attraction attraction;
  Map<String, dynamic> changes = {}; // map between field and change, e.g: "location", "value".

  void initState() {
    super.initState();
    attraction = Provider.of<Data>(context, listen: false).attractions[widget.attractionIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildUpdateAttractionContent(),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: true,
      isEdit: false,
      isSave: false,
      isTabBar: false,
      isShare: true,
      shareOnPressed: () => _takeScreenshot(),
      titleText: '',
      iconsColor: Colors.black,
    );
  }

  void _takeScreenshot() async {
    final imageFile = await screenshotController.capture();
    Share.shareFiles([imageFile.path]);
  }

  Visibility buildBottomNavigationBar() {
    return Visibility(
      visible: !widget.isAdmin,
      child: PrimaryBottomNavigationBar(
          isHome: false, isBrowse: false, isWishList: false, isCart: false),
    );
  }

  Column buildUpdateAttractionContent() {
    return Column(
      children: [
        Screenshot(
          controller: screenshotController,
          child: Column(
            children: [
              buildBigAttractionImage(attraction: attraction),
              buildDetails(),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(15)),
        buildApproveOrRejectButton(),
        SizedBox(height: getProportionateScreenHeight(15)),
      ],
    );
  }

  Container buildDetails() {
    return Container(
      color: Colors.blueGrey[50],
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      width: double.infinity,
      child: buildDetailsText(),
    );
  }

  Column buildDetailsText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(),
        MyDivider(),
        BuildCategory(attraction: attraction, onUpdate: onUpdate, changes: changes),
        MyDivider(),
        buildDescription(),
        MyDivider(),
        buildOpeningAndClosingTime(),
        MyDivider(),
        buildWebSite(),
        MyDivider(),
        BuildPricing(attraction: attraction, onUpdate: onUpdate, changes: changes),
        MyDivider(),
        IsNeedToBuyTickets(attraction: attraction, onUpdate: onUpdate, changes: changes),
        MyDivider(),
        BuildSuitableFor(attraction: attraction, onUpdate: onUpdate, changes: changes),
        MyDivider(),
        BuildSuitableSeason(attraction: attraction, onUpdate: onUpdate, changes: changes),
        MyDivider(),
        buildDuration(),
        MyDivider(),
      ],
    );
  }

  AttractionDetailsCard buildTitle() {
    return AttractionDetailsCard(
      child: Column(
        children: [
          Row(
            children: [
              buildAttractionName(),
              SizedBox(width: getProportionateScreenWidth(2)),
              buildSaveIconButton(),
            ],
          ),
          buildStars(),
        ],
      ),
      height: getProportionateScreenHeight(110),
    );
  }

  Text buildAttractionName() =>
      Text(attraction.name, style: k18BlackStyle, overflow: TextOverflow.ellipsis);

  IconButton buildSaveIconButton() {
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: () {
        if (changes.isNotEmpty) {
          if (widget.isAdmin) {
            FireBaseSingleton().changeAttraction(attraction.getID(), changes);
            Navigator.pop(context);
          } else {
            Provider.of<Data>(context, listen: false).addRequestToFireBase(createUpdatedAttraction(), attraction.getID());
            showSendToConfirmDialog(context: context, numOfPops: 2);
          }
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Attraction createUpdatedAttraction() {
    var category = changes["Category"] ?? attraction.category;
    var webSite = changes["WebSite"] ?? attraction.webSite;
    var openingTime = changes["OpeningTime"] != null
        ? TimeOfDayExtension.timeFromStr(changes["OpeningTime"])
        : attraction.openingTime;
    var closingTime = changes["ClosingTime"] != null
        ? TimeOfDayExtension.timeFromStr(changes["ClosingTime"])
        : attraction.closingTime;
    var description = changes["Description"] ?? attraction.description;
    var duration = changes["Duration"] != null ? TimeOfDayExtension.timeFromStr(changes["Duration"])
        : attraction.duration;
    var isNeedToBuyTickets = changes["IsNeedToBuyTicketsInAdvance"] ?? attraction.isNeedToBuyTickets;
    var suitableFor = changes["SuitableFor"] ?? attraction.suitableFor;
    var suitableSeason = changes["SuitableWeather"] ?? attraction.suitableSeason;
    var pricing = changes["Payment"] ?? attraction.pricing;
    Attraction updated = Attraction(
        status: 2,
        category: category,
        address: attraction.address,
        latLngLocation: attraction.latLngLocation,
        openingTime: openingTime,
        closingTime: closingTime,
        numOfReviews: attraction.numOfReviews,
        description: description,
        country: attraction.country,
        duration: duration,
        isNeedToBuyTickets: isNeedToBuyTickets,
        suitableFor: suitableFor,
        suitableSeason: suitableSeason,
        recommendations: attraction.recommendations,
        pricing: pricing,
        imageSrc: attraction.imageSrc,
        name: attraction.name,
        webSite: webSite,
        rating: attraction.rating,
    priority: 0);
    updated.setID(attraction.getID());
    return updated;
  }

  StarRatingWithNumOfReviews buildStars() {
    return StarRatingWithNumOfReviews(
      numOfReviews: int.parse(attraction.numOfReviews),
      rating: double.parse(attraction.rating),
      starsSize: getProportionateScreenWidth(20),
      alignment: MainAxisAlignment.start,
      isReadOnly: true,
    );
  }

  // add change to changes map
  void onUpdate(String attractionField, String value) {
    setState(() {
      changes[attractionField] = value;
    });
  }

  AttractionDetailsCard buildDescription() {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildDescriptionTextFormField(
            isUpdate: true,
            initialValue: attraction.description,
            onChanged: (value) => onUpdate("Description", value),
          ),
        ],
      ),
      height: getProportionateScreenHeight(190),
    );
  }

  AttractionDetailsCard buildOpeningAndClosingTime() {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Opening time:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          BuildOpeningTimeFormFieldForDetails(
            isUpdate: true,
            context: context,
            setOpeningTime: (newValue) {
              String newValueStr = TimeOfDayExtension(newValue).str();
              if (newValueStr != TimeOfDayExtension(attraction.openingTime).str()) {
                onUpdate("OpeningTime", newValueStr);
              }
            },
            isEnabled: true,
            initialValue: TimeOfDayExtension(attraction.openingTime).str(),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          Text("Closing time:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          BuildClosingTimeFormFieldForDetails(
            isUpdate: true,
            context: context,
            setClosingTime: (newValue) {
              String newValueStr = TimeOfDayExtension(newValue).str();
              if (newValueStr != TimeOfDayExtension(attraction.closingTime).str()) {
                onUpdate("ClosingTime", newValueStr);
              }
            },
            isEnabled: true,
            initialValue: TimeOfDayExtension(attraction.closingTime).str(),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
        ],
      ),
      height: getProportionateScreenHeight(305),
    );
  }

  AttractionDetailsCard buildWebSite() {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Web-site:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildWebSiteTextFormField(
            isUpdate: true,
            initialValue: attraction.webSite,
            onChanged: (value) => onUpdate("WebSite", value),
          ),
        ],
      ),
      height: getProportionateScreenHeight(120),
    );
  }

  AttractionDetailsCard buildDuration() {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Duration:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          BuildDurationTextFormFieldForDetails(
            isUpdate: true,
            context: context,
            setDuration: (newValue) {
              String newValueStr = TimeOfDayExtension(newValue).str();
              if (newValueStr != TimeOfDayExtension(attraction.duration).str()) {
                onUpdate("Duration", newValueStr);
              }
            },
            isEnabled: true,
            initialValue: TimeOfDayExtension(attraction.duration).str(),
          ),
        ],
      ),
      height: getProportionateScreenHeight(160),
    );
  }

  Visibility buildApproveOrRejectButton() {
    Request req = Request(
        updatedAttraction: attraction, sender: Provider.of<Data>(context, listen: false).user.email);
    return Visibility(
      visible: widget.isApproveOrRejectButtonVisible,
      child: ApproveOrRejectButton(request: req, changes: changes),
    );
  }
}

class BuildCategory extends StatefulWidget {
  const BuildCategory({@required this.attraction, this.onUpdate, this.changes});

  final Attraction attraction;
  final Function onUpdate;
  final Map<String, dynamic> changes;

  @override
  State<BuildCategory> createState() => _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  String category;

  @override
  void initState() {
    super.initState();
    category = widget.attraction.category;
  }

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildCategoryField(
            context: context,
            initialValue: category,
            isUpdate: true,
            setCategory: (newValue) {
              if (newValue != widget.attraction.category) {
                widget.onUpdate("Category", newValue);
                setState(() => category = newValue);
              }
            },
          ),
        ],
      ),
      height: getProportionateScreenHeight(120),
    );
  }
}

class BuildPricing extends StatefulWidget {
  const BuildPricing({@required this.attraction, this.onUpdate, this.changes});

  final Attraction attraction;
  final Function onUpdate;
  final Map<String, dynamic> changes;

  @override
  State<BuildPricing> createState() => _BuildPricingState();
}

class _BuildPricingState extends State<BuildPricing> {
  String pricing;

  @override
  void initState() {
    super.initState();
    pricing = widget.attraction.pricing;
  }

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          BuildPricingField(
            isUpdate: true,
            initialValue: pricing,
            setPricing: (newValue) {
              setState(() {
                if (newValue != widget.attraction.suitableSeason) {
                  widget.onUpdate("Payment", newValue);
                  pricing = newValue;
                }
              });
            },
          ),
        ],
      ),
      height: getProportionateScreenHeight(370),
    );
  }
}

class IsNeedToBuyTickets extends StatefulWidget {
  final Attraction attraction;
  final Function onUpdate;
  final Map<String, dynamic> changes;

  const IsNeedToBuyTickets({@required this.attraction, this.onUpdate, this.changes});

  @override
  State<IsNeedToBuyTickets> createState() => _IsNeedToBuyTicketsState();
}

class _IsNeedToBuyTicketsState extends State<IsNeedToBuyTickets> {
  String isNeedToBuyTickets;

  @override
  void initState() {
    super.initState();
    isNeedToBuyTickets = widget.attraction.isNeedToBuyTickets;
  }

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Need to buy tickets?  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          BuildIsNeedToBuyTicketsField(
            setIsNeedToBuyTickets: (newValue) {
              if (newValue != isNeedToBuyTickets) {
                widget.onUpdate("IsNeedToBuyTicketsInAdvance", newValue);
                setState(() => isNeedToBuyTickets = newValue);
              }
            },
            isUpdate: true,
            initialValue: isNeedToBuyTickets,
          ),
        ],
      ),
      height: getProportionateScreenHeight(140),
    );
  }
}

class BuildSuitableFor extends StatefulWidget {
  const BuildSuitableFor({@required this.attraction, this.onUpdate, this.changes});

  final Attraction attraction;
  final Function onUpdate;
  final Map<String, dynamic> changes;

  @override
  State<BuildSuitableFor> createState() => _BuildSuitableForState();
}

class _BuildSuitableForState extends State<BuildSuitableFor> {
  String suitableFor;

  @override
  void initState() {
    super.initState();
    suitableFor = widget.attraction.suitableFor;
  }

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable for:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildSuitableForField(
            context: context,
            initialValue: suitableFor,
            isUpdate: true,
            setSuitableFor: (newValue) {
              if (newValue != widget.attraction.suitableFor) {
                widget.onUpdate("SuitableFor", newValue);
                setState(() => suitableFor = newValue);
              }
            },
          ),
        ],
      ),
      height: getProportionateScreenHeight(120),
    );
  }
}

class BuildSuitableSeason extends StatefulWidget {
  const BuildSuitableSeason({@required this.attraction, this.onUpdate, this.changes});

  final Attraction attraction;
  final Function onUpdate;
  final Map<String, dynamic> changes;

  @override
  State<BuildSuitableSeason> createState() => _BuildSuitableSeasonState();
}

class _BuildSuitableSeasonState extends State<BuildSuitableSeason> {
  String suitableSeason;

  @override
  void initState() {
    super.initState();
    suitableSeason = widget.attraction.suitableSeason;
  }

  @override
  Widget build(BuildContext context) {
    return AttractionDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Suitable season:  ", style: k13GreenStyle),
          SizedBox(height: getProportionateScreenHeight(5)),
          buildSuitableSeasonField(
            context: context,
            initialValue: suitableSeason,
            isUpdate: true,
            setSuitableSeason: (newValue) {
              if (newValue != widget.attraction.suitableSeason) {
                widget.onUpdate("SuitableWeather", newValue);
                setState(() => suitableSeason = newValue);
              }
            },
          ),
        ],
      ),
      height: getProportionateScreenHeight(120),
    );
  }
}
