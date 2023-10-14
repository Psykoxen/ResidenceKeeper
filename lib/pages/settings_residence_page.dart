import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/animations/delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/models/residence_model.dart';
import 'package:residencekeeper/pages/logger_page.dart';
import 'package:residencekeeper/pages/welcome_page.dart';

class SettingsPage extends StatelessWidget {
  final Future<ResidenceModel> residence;

  SettingsPage({required this.residence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: MySettingsForm(
              residence: residence), // Utilisation du formulaire personnalisé
        ),
      ),
    );
  }
}

class MySettingsForm extends StatefulWidget {
  final Future<ResidenceModel> residence;

  MySettingsForm({required this.residence});

  @override
  _MySettingsFormState createState() => _MySettingsFormState();
}

class _MySettingsFormState extends State<MySettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // Déclarez une variable pour stocker la valeur du champ "Residence name"
  String _residenceName = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResidenceModel>(
      future: widget.residence,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final residence = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: residence!.home.name,
                  decoration: InputDecoration(labelText: 'Residence name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un nom de résidence';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _residenceName = value!;
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(d_main),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Vous pouvez traiter la valeur du champ "Residence name" ici
                          print('Nom de résidence : $_residenceName');
                        }
                      },
                      child: Text('Save', style: GoogleFonts.poppins()),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                        );
                      },
                      child: Text('Delete', style: GoogleFonts.poppins()),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Divider(
                  thickness: 1.0, // Épaisseur de la ligne de séparation
                ),
                SizedBox(height: 10.0),
                Text(
                  'Members',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w500, color: d_main),
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: residence.balance.length,
                //   itemBuilder: (context, index) {
                //     final member = residence.members[index];
                //     return ListTile(
                //       title: Text(member.name),
                //       // Vous pouvez personnaliser l'apparence du nom du membre ici
                //     );
                //   },
                // )
              ],
            ),
          );
        } else {
          // Afficher un indicateur de chargement ou un message d'erreur
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
