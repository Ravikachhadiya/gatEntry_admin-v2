import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/add_city_widget.dart';
import '../widgets/city_widget.dart';

class SocietyScreen extends StatefulWidget {
  static const routeName = 'society';

  @override
  _SocietyScreenState createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  void _addSociety(BuildContext ctx, String cityId) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddCityWidget(2, cityId),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
  Stream<QuerySnapshot> _societyData(String cityId) {
    return Firestore.instance
        .collection('society')
        .where("cityId", isEqualTo: cityId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final cityId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Society'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _societyData(cityId),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text("Empty 1 !"),
            );
          }
          final data = snapshot.data.documents;
          print("Data : " + data.toString());
          return data.toString() == '[]'
              ? Center(
                  child: Text("Empty 2!"),
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
                      2,
                    );
                  },
                );
        },
      ),
      floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSociety(context, cityId);
        },
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
