import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/add_city_widget.dart';
import '../widgets/city_widget.dart';

class BuildingScreen extends StatefulWidget {
  static const routeName = 'building';
  @override
  _BuildingScreenState createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  void _addBuilding(BuildContext ctx, String societyId) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddCityWidget(3, societyId),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final societyId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Building'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('building')
            .where("societyId", isEqualTo: societyId)
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
                        "name": data[i]["name"],
                        "id": data[i].documentID,
                      },
                      3,
                    );
                  },
                );
        },
      ),
      floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addBuilding(context, societyId);
        },
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
