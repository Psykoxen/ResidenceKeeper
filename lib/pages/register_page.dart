import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/animations/delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residencekeeper/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: DelayedAnimation(
              delay: 200,
              child: Column(children: [
                Container(
                  child: SvgPicture.asset('assets/images/city.svg'),
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text(
                  "Join Us ! ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: d_main,
                  ),
                ),
                const SizedBox(height: 30),
                RegisterForm()
              ])),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(); // Clé du formulaire

  // Variables pour stocker les valeurs des champs de saisie
  String _username = '';
  String _email = '';
  String _password = '';
  String _password_confirmed = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Champ de saisie pour le nom d'utilisateur
          TextFormField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
                labelText: 'Username', labelStyle: GoogleFonts.poppins()),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez saisir votre nom d\'utilisateur';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          // Champ de saisie pour l'adresse e-mail
          TextFormField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
                labelText: 'E-mail', labelStyle: GoogleFonts.poppins()),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez saisir votre adresse e-mail';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          // Champ de saisie pour le mot de passe
          TextFormField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: 'Password',
              // Couleur de l'étiquette en sélection
            ),
            obscureText: true, // Masquer le texte du mot de passe
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez saisir votre mot de passe';
              } else if (value != _password_confirmed) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          // Champ de saisie pour la confirmation du mot de passe
          TextFormField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
                labelText: 'Password confirmation',
                labelStyle: GoogleFonts.poppins()
                // Couleur de l'étiquette en sélection
                ),
            obscureText: true, // Masquer le texte du mot de passe
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              } else if (value != _password) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            onSaved: (value) {
              _password_confirmed = value!;
            },
          ),
          // Bouton de connexion
          const SizedBox(height: 20),
          Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Vérifiez si le compte existe (voir ci-dessous
                    _formKey.currentState!.save();
                    checkAccountExistence(_email, _password);
                    // Ici, vous pouvez traiter la connexion avec les valeurs de _email et _password
                    // Par exemple, authentifiez-vous auprès de votre API backend
                    // Si la connexion est réussie, vous pouvez naviguer vers la page suivante
                    // avec Navigator.pushNamed(context, '/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: d_main,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(13),
                ),
                child: Text('Register', style: GoogleFonts.poppins()),
              )),
        ],
      ),
    );
  }
}

Future<void> checkAccountExistence(String email, String keypass) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.128:8080/api/user/Register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'keypass': keypass,
    }),
  );

  if (response.statusCode == 200) {
    log("Logged");
    // La requête a réussi, analysez la réponse ici.
    // Vous pouvez utiliser la bibliothèque dart:convert pour décoder la réponse JSON si elle est renvoyée par l'API.
    // Par exemple : var data = json.decode(response.body);
    // Ensuite, vous pouvez vérifier si le compte existe dans les données renvoyées par l'API.
  } else {
    log("Not logged");
    // La requête a échoué. Gérez les erreurs ici.
  }
}
