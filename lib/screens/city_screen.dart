import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/add_city_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/city_widget.dart';

class CityScreen extends StatefulWidget {
  static const routeName = 'city';

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  void _addCity(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddCityWidget(1,null),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City'),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder(
        stream: Firestore.instance.collection('city').orderBy('name').snapshots(),
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
                      1,
                    );
                  },
                );
        },
      ),
      floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCity(context);
        },
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
