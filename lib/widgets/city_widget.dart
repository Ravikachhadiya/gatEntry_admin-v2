import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/building_screen.dart';
import '../screens/house_number_screen.dart';
import '../screens/society_screen.dart';

class CityWidget extends StatelessWidget {
  final Map<String, String> city;
  final int code;

  CityWidget(this.city, this.code);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: ListTile(
          title: Text(
            city['name'][0].substring(0, 1).toUpperCase() +
                city['name'].substring(1),
            style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text(
                    'Do you want to remove the entry?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Delete'),
                      onPressed: () {
                        if (code == 1) {
                          print("Helaro 1 ");
                          Firestore.instance
                              .collection('city')
                              .document(city['id'])
                              .delete();
                          Firestore.instance
                              .collection('society')
                              .where("cityId", isEqualTo: city['id'])
                              .getDocuments()
                              .then((valueSociety) {
                            for (int i = 0;
                                i <= valueSociety.documents.length;
                                i++) {
                              Firestore.instance
                                  .collection('society')
                                  .document(
                                      valueSociety.documents[i].documentID)
                                  .delete();
                              Firestore.instance
                                  .collection('building')
                                  .where("societyId",
                                      isEqualTo:
                                          valueSociety.documents[i].documentID)
                                  .getDocuments()
                                  .then((valueBuilding) {
                                for (int j = 0;
                                    j <= valueBuilding.documents.length;
                                    j++) {
                                  Firestore.instance
                                      .collection('building')
                                      .document(
                                          valueBuilding.documents[j].documentID)
                                      .delete();
                                  Firestore.instance
                                      .collection('houseNumber')
                                      .where("buildingId",
                                          isEqualTo: valueBuilding
                                              .documents[j].documentID)
                                      .getDocuments()
                                      .then((valueHouseNumber) {
                                    for (int k = 0;
                                        k <= valueHouseNumber.documents.length;
                                        k++) {
                                      Firestore.instance
                                          .collection('houseNumber')
                                          .document(valueHouseNumber
                                              .documents[k].documentID)
                                          .delete();
                                    }
                                  });
                                }
                              });
                            }
                          });
                        } else if (code == 2) {
                          print("Helaro 2 ");
                          Firestore.instance
                              .collection('society')
                              .document(city['id'])
                              .delete();
                          print("code 2.0 :" + city['id']);
                          Firestore.instance
                              .collection('building')
                              .where("societyId", isEqualTo: city['id'])
                              .getDocuments()
                              .then((valueBuilding) {
                            for (int j = 0;
                                j <= valueBuilding.documents.length;
                                j++) {
                              print("code 2.1 :" +
                                  valueBuilding.documents[j].documentID);
                              Firestore.instance
                                  .collection('building')
                                  .document(
                                      valueBuilding.documents[j].documentID)
                                  .delete();
                              Firestore.instance
                                  .collection('houseNumber')
                                  .where("buildingId",
                                      isEqualTo:
                                          valueBuilding.documents[j].documentID)
                                  .getDocuments()
                                  .then((valueHouseNumber) {
                                for (int k = 0;
                                    k <= valueHouseNumber.documents.length;
                                    k++) {
                                  print("code 2.2 :" +
                                      valueHouseNumber.documents[k].documentID);

                                  Firestore.instance
                                      .collection('houseNumber')
                                      .document(valueHouseNumber
                                          .documents[k].documentID)
                                      .delete();
                                }
                              });
                            }
                          });
                        } else if (code == 3) {
                          print("Helaro 3");

                          Firestore.instance
                              .collection('building')
                              .document(city['id'])
                              .delete();

                          Firestore.instance
                              .collection('houseNumber')
                              .where("buildingId", isEqualTo: city['id'])
                              .getDocuments()
                              .then((valueHouseNumber) {
                            for (int k = 0;
                                k <= valueHouseNumber.documents.length;
                                k++) {
                              Firestore.instance
                                  .collection('houseNumber')
                                  .document(
                                      valueHouseNumber.documents[k].documentID)
                                  .delete();
                            }
                          });
                        } else if (code == 4) {
                          print("Helaro 4");

                          Firestore.instance
                              .collection('houseNumber')
                              .document(city['id'])
                              .delete();
                        }
                        Navigator.of(context).pop();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Deleted Successfully',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        onTap: () {
          code == 1
              ? Navigator.of(context).pushNamed(
                  SocietyScreen.routeName,
                  arguments: city['id'],
                )
              : code == 2
                  ? Navigator.of(context).pushNamed(
                      BuildingScreen.routeName,
                      arguments: city['id'],
                    )
                  : code == 3
                      ? Navigator.of(context).pushNamed(
                          HouseNumberScreen.routeName,
                          arguments: city['id'],
                        )
                      : null;
        },
      ),
    );
  }
}
