import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/add_city_widget.dart';
import '../widgets/city_widget.dart';

class HouseNumberScreen extends StatefulWidget {
  static const routeName = 'house-number';

  @override
  _HouseNumberScreenState createState() => _HouseNumberScreenState();
}

class _HouseNumberScreenState extends State<HouseNumberScreen> {
  void _addHouseNumber(BuildContext ctx,String buildingId) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddCityWidget(4,buildingId),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final buildingId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('House Number'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('houseNumber')
            .where("buildingId", isEqualTo: buildingId)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text("Empty!"),
            );
          }
          final data = snapshot.data.documents;
          print("Data : " + data.toString());
          return data.toString() == '[]'
              ? Center(
                  child: Text("Empty!"),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    print(data[i].documentID);
                    return CityWidget(
                      {
                        "name": data[i]["number"].toString(),
                        "id": data[i].documentID,
                      },
                      4,
                    );
                  },
                );
        },
      ),
      floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addHouseNumber(context, buildingId);
        },
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
