import '../providers/approval_request.dart';
import '../widgets/approval_request_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApprovalRequestScreen extends StatelessWidget {
  static const routeName = '/approval-request-screen';

  Stream<QuerySnapshot> _approvalRequestData() {
    return Firestore.instance
        .collection("approvalRequest")
        .orderBy("date", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _approvalRequestData(),
        builder: (ctx, snapshot) {
          print("snapshot : " + snapshot.data.toString());
          if (snapshot.data == null) {
            return Center(
              child: Text("No request is here!"),
            );
          }
          final data = snapshot.data.documents;
          print("Data : " + data.toString());
          return data.toString() == '[]'
              ? Center(
                  child: Text("No request is here!"),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    return ApprovalRequestWidget(
                      ApprovalRequest(
                        id: data[i].documentID,
                        buildingId: data[i]['buildingId'],
                        societyId: data[i]['societyId'],
                        houseNumberId: data[i]['houseNumberId'],
                        userId: data[i]['userId'],
                        status: data[i]['status'],
                      ),
                    );
                  },
                  padding: EdgeInsets.only(bottom: 70),
                );
        },
      ),
    );
  }
}
