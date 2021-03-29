import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ApprovalRequest extends ChangeNotifier {
  final String id;
  final String userId;
  final String buildingId;
  final String houseNumberId;
  final String societyId;
  final bool status;

  ApprovalRequest({
    @required this.id,
    @required this.userId,
    @required this.buildingId,
    @required this.houseNumberId,
    @required this.societyId,
    this.status,
  });

  void addApprovalRequest(ApprovalRequest approvalRequest, bool userType) {
    Map<String, dynamic> approvalRequestData = {
      "userId": approvalRequest.userId,
      "houseNumberId": approvalRequest.houseNumberId,
      "status": approvalRequest.status,
      "buildingId": approvalRequest.buildingId,
      "societyId": approvalRequest.societyId,
      "date": DateTime.now(),
    };

    if (userType) {
      CollectionReference collectionReference =
          Firestore.instance.collection('society');

      collectionReference
          .document(approvalRequest.societyId)
          .collection('approvalRequest')
          .add(approvalRequestData);
    } else {
      Firestore.instance.collection('approvalRequest').add(approvalRequestData);
    }

    notifyListeners();
  }

  void updateApprovalRequest(ApprovalRequest approvalRequest) {
    Map<String, dynamic> approvalRequestData = {
      "userId": approvalRequest.userId,
      "houseNumberId": approvalRequest.houseNumberId,
      "status": approvalRequest.status,
      "buildingId": approvalRequest.buildingId,
      "societyId": approvalRequest.societyId,
      "date": DateTime.now(),
    };

    Firestore.instance
        .collection("approvalRequest")
        .document(approvalRequest.id)
        .setData(approvalRequestData);

    CollectionReference collectionReferenceUser =
        Firestore.instance.collection('users');

    collectionReferenceUser
        .document(approvalRequest.userId)
        .updateData({'approvalStatus': approvalRequest.status});
    notifyListeners();
  }
}
