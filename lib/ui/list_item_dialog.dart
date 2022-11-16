

import 'package:app_persistencia/models/list_items.dart';
import 'package:app_persistencia/utils/dbhelper.dart';
import 'package:flutter/material.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();

    if(!isNew){
    txtName.text=item.name;
    txtQuantity.text=item.quantity;
    txtNote.text=item.note;
    }
    return AlertDialog(
    title: Text((isNew)?'New Item':"Edit Item"),
    content: SingleChildScrollView(
    child: Column(
    children: <Widget>[
    TextField(controller: txtName, decoration: InputDecoration(hintText: 'Item Name'),),
    TextField(controller: txtQuantity, decoration: InputDecoration(hintText: 'Item Quantity'),),
    TextField(controller: txtNote, decoration: InputDecoration(hintText: 'item Note'),),
    ElevatedButton(
    onPressed: (){
    item.name=txtName.text;
    item.quantity=txtQuantity.text;
    item.note=txtNote.text;
    helper.insertItem(item);
    Navigator.pop(context);
    },
    child: Text('Save Item')
    )

    ],
    )
    ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );

  }
}