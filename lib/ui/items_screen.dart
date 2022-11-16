import 'package:app_persistencia/ui/list_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_persistencia/utils/dbhelper.dart';
import 'package:app_persistencia/models/shopping_list.dart';
import 'package:app_persistencia/models/list_items.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemScreen(this.shoppingList);

  @override
  State<ItemScreen> createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);

  //DbHelper? helper;
  DbHelper helper = DbHelper();
  List<ListItem> items=[];

  @override
  Widget build(BuildContext context) {
    ListItemDialog dialog=ListItemDialog();
    helper=DbHelper();

    showData(this.shoppingList.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null)? items.length : 0,
          itemBuilder: (BuildContext context, int index){
          return Dismissible(
              key: Key(items[index].name),
              onDismissed: (direction){
                String strName= items[index].name;
                helper.deleteItem(items[index]);
                setState(() {
                  items.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
              },
              child: ListTile(
            title: Text(items[index].name),
            subtitle: Text('Quantity: ${items[index].quantity} - Note: ${items[index].note}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                showDialog(context: context,
                    builder: (BuildContext context)=> dialog.buildDialog(context, items[index], false));
              },
            ),
          ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context)=>
              dialog.buildDialog(context, ListItem(0, shoppingList.id, '', '', 'note'), true),);
        },
      ),
    );
  }

  Future showData(int idList) async{
    await helper.openDb();
    items = await helper.getItems(idList);

    setState(() {
      items = items;
    });
  }
}








