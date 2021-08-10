import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/my_notification.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class ApproveOrRejectButton extends StatelessWidget {
  final Request request;
  final Map<String, dynamic> changes;
  final Attraction original;

  const ApproveOrRejectButton({@required this.request, this.changes, this.original});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildApproveButton(context),
            SizedBox(width: getProportionateScreenWidth(20)),
            buildRejectButton(context),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
      ],
    );
  }

  DefaultButton buildApproveButton(BuildContext context) {
    return DefaultButton(
      text: "Approve",
      press: () {
        if (request.updatedAttraction.status==2){
          Provider.of<Data>(context, listen: false)
              .ApproveUpdateAttractionInFireBase(request, original);
        } else{
          Provider.of<Data>(context, listen: false).addAttraction(request.updatedAttraction);
        }
        Provider.of<Data>(context, listen: false).deleteRequest(request);

        MyNotification notification = createApproveNotification();
        Provider.of<Data>(context, listen: false).addNotificationToFireBase(notification);
        Navigator.pop(context);
      },
      textColor: Colors.black,
      width: getProportionateScreenWidth(160),
    );
  }

  MyNotification createApproveNotification() {
    return MyNotification(
      title:
          "The '${request.updatedAttraction.name}' attraction you updated/added has been approved by the admin",
      sender: "admin",
      receiver: request.sender,
      now: DateTime.now().toString().substring(0, 16),
      isNew: true,
    );
  }

  Padding buildRejectButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: DefaultButton(
        text: "Reject",
        press: () {
          Provider.of<Data>(context, listen: false).deleteRequest(request);
          MyNotification notification = createRejectNotification();
          Provider.of<Data>(context, listen: false).addNotificationToFireBase(notification);
          Navigator.pop(context);
        },
        textColor: Colors.black,
        width: getProportionateScreenWidth(160),
      ),
    );
  }

  MyNotification createRejectNotification() {
    return MyNotification(
      title:
          "The '${request.updatedAttraction.name}' attraction you updated/added has been rejected by the admin",
      sender: "admin",
      receiver: request.sender,
      now: DateTime.now().toString().substring(0, 16),
      isNew: true,
    );
  }
}
