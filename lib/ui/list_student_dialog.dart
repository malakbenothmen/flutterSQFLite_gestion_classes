import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date
import '../util/dbuse.dart';
import '../models/list_etudiants.dart';

class ListStudentDialog {
  final txtNom = TextEditingController();
  final txtPrenom = TextEditingController();
  final txtdatNais = TextEditingController();

  // Fonction pour sélectionner une date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // Mettre la date au format yyyy-MM-dd dans le TextField
      txtdatNais.text = DateFormat("yyyy-MM-dd").format(selectedDate);
    }
  }

  Widget buildAlert(BuildContext context, ListEtudiants student, bool isNew) {
    dbuse helper = dbuse();

    if (!isNew) {
      txtNom.text = student.nom;
      txtPrenom.text = student.prenom;
      txtdatNais.text = student.datNais;
    }

    return AlertDialog(
      title: Text((isNew) ? 'New Student' : 'Edit Student'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Champ pour le nom de famille
            TextField(controller: txtNom, decoration: InputDecoration(hintText: 'Last Name')),

            // Champ pour le prénom
            TextField(controller: txtPrenom, decoration: InputDecoration(hintText: 'First Name')),

            // Champ pour la date de naissance avec un sélecteur de date
            GestureDetector(
              onTap: () => _selectDate(context), // Ouvre le sélecteur de date
              child: AbsorbPointer( // Empêche l'utilisateur de taper dans le champ
                child: TextField(
                  controller: txtdatNais,
                  decoration: InputDecoration(hintText: 'Date of Birth'),
                  readOnly: true, // Le champ est en lecture seule
                ),
              ),
            ),

            // Bouton pour enregistrer les données
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                student.nom = txtNom.text;
                student.prenom = txtPrenom.text;
                student.datNais = txtdatNais.text;
                helper.insertEtudiants(student);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
