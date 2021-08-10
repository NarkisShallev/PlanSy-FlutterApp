import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/cards/trip_card.dart';
import 'package:plansy_flutter_app/components/cards/trip_plus_card.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:provider/provider.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, tripData, child) {
        return ListView.builder(
          padding: const EdgeInsets.only(left: 22.0, top: 8.0, right: 8.0, bottom: 8.0),
          itemBuilder: (context, index) {
            // checking if the index item is the last item of the list or not
            if (index != tripData.tripsCount) {
              return buildTripCardInstance(tripData, index);
            }
            return TripPlusCard();
          },
          itemCount: tripData.tripsCount + 1,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.horizontal,
        );
      },
    );
  }

  TripCard buildTripCardInstance(Data tripData, int index) {
    final trip = tripData.trips[index];
    return TripCard(
      tripIndex: index,
      removeFromListCallback: () => tripData.deleteTrip(trip, context),
    );
  }
}
