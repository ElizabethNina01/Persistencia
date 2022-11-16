import 'package:flutter/material.dart';
import 'package:app_persistencia/utils/dbhelper.dart';
import 'package:app_persistencia/models/shopping_list.dart';
import 'package:app_persistencia/models/list_items.dart';
import 'package:app_persistencia/ui/shopping_list_dialog.dart';
import 'package:app_persistencia/ui/items_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DbHelper helper = DbHelper();
    //helper.testDB();

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Showlist(),
    );
  }
}

class Showlist extends StatefulWidget {
  const Showlist({Key? key}) : super(key: key);

  @override
  State<Showlist> createState() => _ShowlistState();
}

class _ShowlistState extends State<Showlist> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppinglist=[];

  ShoppingListDialog? dialog;
  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text("My shopping list!"),
      ),
      body: ListView.builder(
        itemCount: (shoppinglist != null)? shoppinglist.length : 0,
          itemBuilder: (BuildContext context, int index){
          return Dismissible(key: Key(shoppinglist[index].name),
            onDismissed: (direction){
              String strName=shoppinglist[index].name;
              helper.deleteList(shoppinglist[index]);
              setState(() {
                shoppinglist.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
            title: Text(shoppinglist[index].name),
            leading: CircleAvatar(
            child: Text(shoppinglist[index].priority.toString()),
            ),
            trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
            showDialog(
            context: context,
            builder: (BuildContext context) =>
            dialog!.buildDialog(
            context, shoppinglist[index], false));
            },
            ),
            onTap: (){
            Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ItemScreen(shoppinglist[index])
            ),
            );
            },
            ));
            }
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog!.buildDialog(
                      context, ShoppingList(0, '', 0), true));
        },
        child: Icon(Icons.add_box_outlined),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future showData() async{
    await helper.openDb();
    shoppinglist = await helper.getLists();

    setState(() {
      shoppinglist = shoppinglist;
    });
  }
}