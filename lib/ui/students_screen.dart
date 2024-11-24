import 'package:flutter/material.dart';
import '../util/dbuse.dart';
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../ui/list_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() => _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;
  dbuse helper = dbuse();
  List<ListEtudiants> students = [];

  _StudentsScreenState(this.scolList);

  @override
  void initState() {
    super.initState();
    showData(scolList.codClass);
  }

  Future showData(int codClass) async {
    await helper.openDb();
    students = await helper.getEtudiants(codClass);
    setState(() {
      students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    ListStudentDialog dialog = ListStudentDialog();

    return Scaffold(
      appBar: AppBar(
        title: Text(scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(students[index].nom),
            onDismissed: (direction) {
              helper.deleteStudent(students[index]);
              setState(() {
                students.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${students[index].nom} deleted")),
              );
            },
            child: ListTile(
              title: Text(students[index].nom),
              subtitle: Text('Prenom: ${students[index].prenom} - Date Nais: ${students[index].datNais}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => dialog.buildAlert(context, students[index], false),
                  ).then((value) => showData(scolList.codClass));
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
            builder: (context) => dialog.buildAlert(context, ListEtudiants(0, scolList.codClass, '', '', ''), true),
          ).then((value) => showData(scolList.codClass));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
