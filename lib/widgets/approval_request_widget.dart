import '../providers/approval_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ApprovalRequestWidget extends StatelessWidget {
  final ApprovalRequest approvalRequest;

  ApprovalRequestWidget(this.approvalRequest);

  String name = "";

  String city = "";

  String society = "";

  String building = "";

  String houseNumber = "";

  void userData() async {
    final nameData = await Firestore.instance
        .collection('users')
        .document(approvalRequest.userId)
        .get();
    name = nameData.data['name'];

    final societyData = await Firestore.instance
        .collection('society')
        .document(approvalRequest.societyId)
        .get();
    society = societyData.data['name'].toString();
    var cityId = societyData.data['cityId'].toString();

    final cityData =
        await Firestore.instance.collection('city').document(cityId).get();
    city = cityData.data['name'].toString();

    final buildingData = await Firestore.instance
        .collection('building')
        .document(approvalRequest.buildingId)
        .get();
    building = buildingData.data['name'].toString();

    final houseNumberData = await Firestore.instance
        .collection('houseNumber')
        .document(approvalRequest.houseNumberId)
        .get();
    houseNumber = houseNumberData.data['number'].toString();
  }

  @override
  Widget build(BuildContext context) {
    userData();
    print("DATA of  : "  + name + " " + city + " " + society + " " + building +  " " + houseNumber);
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 8,
      shadowColor: approvalRequest.status == false
          ? Colors.red
          : approvalRequest.status == true
              ? Colors.greenAccent
              : Colors.black87,
      child: (name == '' || city == '' || society == '' || building == '' || houseNumber == '')
          ? Center(
              child: CircularProgressIndicator(),
            )
          : approvalRequest.status != null
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '$name',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$building $houseNumber',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '$society',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$city',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : InkWell(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 15, left: 15, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '$name',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$building $houseNumber',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '$society',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$city',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: OutlineButton(
                                  borderSide: BorderSide(
                                      width: 2.5, color: Colors.greenAccent),
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  highlightedBorderColor: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Provider.of<ApprovalRequest>(context,
                                            listen: false)
                                        .updateApprovalRequest(ApprovalRequest(
                                      id: approvalRequest.id,
                                      buildingId:
                                          approvalRequest.buildingId,
                                      societyId:
                                          approvalRequest.societyId,
                                      houseNumberId:
                                          approvalRequest.houseNumberId,
                                      userId: approvalRequest.userId,
                                      status: true,
                                    ));
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: OutlineButton(
                                  child: Text(
                                    "Reject",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  borderSide:
                                      BorderSide(width: 2.5, color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    Provider.of<ApprovalRequest>(context,
                                            listen: false)
                                        .updateApprovalRequest(ApprovalRequest(
                                      id: approvalRequest.id,
                                      buildingId:
                                          approvalRequest.buildingId,
                                      societyId:
                                          approvalRequest.societyId,
                                      houseNumberId:
                                          approvalRequest.houseNumberId,
                                      userId: approvalRequest.userId,
                                      status: false,
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
