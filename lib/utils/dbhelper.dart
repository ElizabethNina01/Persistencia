import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_persistencia/models/shopping_list.dart';
import 'package:app_persistencia/models/list_items.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  //se controla que solo se abra 1 instancia de la BD
  static final DbHelper dbHelper = DbHelper.internal();

  DbHelper.internal();

  factory DbHelper(){
    //patron singleton
    return dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      //no existe la BD
      db = await openDatabase(join(await getDatabasesPath(),
          'compras_2.db'),
          onCreate: (database, version) {
            database.execute(
                'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
            database.execute(
                'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, '
                    'quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
          }, version: version);
    }
    return db!;
  }

  //este metodo ya no se usara!!
  Future testDB() async {
    db = await openDb();

    await db!.execute('INSERT INTO lists VALUES (0, "Video", 1)');
    await db!.execute(
        'INSERT INTO items VALUES (0, 0, "Tarjeta Video", "1", "Nvidia 8GB")');

    List list = await db!.rawQuery('SELECT * FROM lists');
    List item = await db!.rawQuery('SELECT * FROM items');

    print(list[0]);
    print(item[0]);
  }

  //Aqui se implementan los metodos CRUD
  Future<int> insertList(ShoppingList list) async {
    int id = await db!.insert(
        'lists',
        list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); //super importante
    // esta propiedad hace q este metodo funcioen como "insert" y "update"

    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await db!.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); //super importante

    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i) {
      return ShoppingList(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['priority']
      );
    });
  }

  Future<int?> deleteList(ShoppingList list) async{
    int? result=await db?.delete("items", where: "idList=?", whereArgs: [list.id]);
    result=await db?.delete("lists", where: "id=?", whereArgs: [list.id]);
    return result;
  }


  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps =
    await db!.query('items', where: 'idList = ?', whereArgs: [idList]);

    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }

  Future<int?> deleteItem(ListItem item) async{
    int? result= await db?.delete("items", where: "id=?",whereArgs: [item.id]);
    return result;
  }
}












