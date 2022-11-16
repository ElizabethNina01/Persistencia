import 'package:flutter/material.dart';
import 'package:app_persistencia/utils/dbhelper.dart';
import 'package:app_persistencia/models/shopping_list.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPrority = TextEditingController();

  //isNew
  //--> false = edit
  //--> true = new
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if (!isNew){
      txtName.text = list.name;
      txtPrority.text = list.priority.toString();
    }
    else{
      txtName.text = "";
      txtPrority.text = "";
    }

    return AlertDialog(
      title: Text((isNew)? "New shopping list" : "Edit shopping list"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: "Name:"
              ),
            ),
        TextField(
          controller: txtPrority,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: "Priority (1 - 3):"
          ),
        ),
            ElevatedButton(
                onPressed: (){
                  list.name = txtName.text;
                  list.priority = int.parse(txtPrority.text);
                  helper.insertList(list);
                  Navigator.pop(context);
            },
                child: Text("Save")
            )
          ],
        ),
        ),
      );
  }
}