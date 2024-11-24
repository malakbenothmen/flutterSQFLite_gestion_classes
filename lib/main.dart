import 'package:flutter/material.dart';
import 'util/dbuse.dart';
import 'models/scol_list.dart';
import 'ui/students_screen.dart';
import 'ui/scol_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  dbuse helper = dbuse();
  ScolListDialog dialog = ScolListDialog();

  @override
  void initState() {
    super.initState();
    showData();
  }

  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes List'),
      ),
      body: ListView.builder(
        itemCount: scolList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(scolList[index].nomClass),
            onDismissed: (direction) {
              String className = scolList[index].nomClass;
              helper.deleteList(scolList[index]);
              setState(() {
                scolList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("class'$className' deleted")),
              );
            },
            child: ListTile(
              title: Text(scolList[index].nomClass),
              leading: CircleAvatar(child: Text(scolList[index].codClass.toString())),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentsScreen(scolList[index])),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => dialog.buildDialog(context, scolList[index], false),
                  ).then((value) => showData());
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => dialog.buildDialog(context, ScolList(0, '', 0), true),
          ).then((value) => showData());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
