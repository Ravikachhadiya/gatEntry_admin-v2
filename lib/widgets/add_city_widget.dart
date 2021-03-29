import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCityWidget extends StatefulWidget {
  final int code;
  final String documentId;
  AddCityWidget(this.code, this.documentId);
  @override
  _AddCityWidgetState createState() => _AddCityWidgetState();
}

class _AddCityWidgetState extends State<AddCityWidget> {
  final _form = GlobalKey<FormState>();

  String _documentId = null;
  String newValue = null;
  bool _submit = true;

  void getDocumentIdOfState(String stateName) {
    CollectionReference collectionReference =
        Firestore.instance.collection('state');

    collectionReference.snapshots().listen((snapshot) {
      //print("snapshot : " + snapshot.documents[0].data.toString());
      var stateList = snapshot.documents;

      for (int i = 0; i < stateList.length; i++) {
        if (stateList[i]['name'] == stateName) {
          _documentId = stateList[i].documentID;
        }
      }
    });
  }

  void _addCity(String name) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final String idName = widget.code == 1
        ? "stateId"
        : widget.code == 2
            ? "cityId"
            : widget.code == 3
                ? "societyId"
                : "buildingId";
    try {
      Map<String, dynamic> data = {};
      print("data : " + data.toString() + "\nidName : " + idName);
      widget.code == 4
          ? data = {
              "number": int.parse(newValue),
              "$idName": widget.documentId,
            }
          : widget.code == 1
              ? data = {
                  "name": newValue.toLowerCase(),
                  "$idName": _documentId,
                }
              : data = {
                  "name": newValue,
                  "$idName": widget.documentId,
                };
      print("data : " +
          data.toString() +
          "\nidName : " +
          idName +
          "\nname :  " +
          name);
      widget.code == 4
          ? Firestore.instance.collection("houseNumber").add(data)
          : Firestore.instance.collection(name.toLowerCase()).add(data);
    } catch (error) {
      //print(error);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                _submit = false;
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
    if (_submit) Navigator.of(context).pop();
  }

  Widget stateDropdown() {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('state').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(
            child: const CupertinoActivityIndicator(),
          );
        return DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'State'),
            items: snapshot.data.documents.map((DocumentSnapshot document) {
              //print("----> " + document.documentID);
              return new DropdownMenuItem<String>(
                value: document.data['name'],
                child: new Text(document.data['name']),
              );
            }).toList(),
            validator: (value) {
              if (value == null && widget.code == 1) {
                return 'Please choose your state';
              }
              return null;
            },
            onChanged: (value) {
              setState(
                () {
                  getDocumentIdOfState(value);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              );
            },
            onSaved: (value) {
              getDocumentIdOfState(value);
            });
      },
    );
  }

  Widget signupButton(String name) {
    return RaisedButton(
      child: Text(
        'SUBMIT',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _addCity(name);
      },
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Theme.of(context).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.code == 1
        ? "City"
        : widget.code == 2
            ? "Society"
            : widget.code == 3
                ? "Building"
                : "House Number";
    final String hintText = widget.code == 1
        ? "Surat"
        : widget.code == 2
            ? "Shubh Vatika"
            : widget.code == 3
                ? "A"
                : "101";
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    if (widget.code == 1) ...[
                      stateDropdown(),
                    ],
                    TextFormField(
                      //initialValue: _initValues['name'],
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: '$name Name', hintText: '$hintText'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        //print(value);
                        if (value.isEmpty) {
                          return 'Please provide a ${name.toLowerCase()}.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newValue = value;
                        });
                      },
                      onSaved: (value) {
                        newValue = value;
                      },
                    ),
                    SizedBox(height: 50),
                    if (newValue != null) ...[
                      signupButton(name),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
