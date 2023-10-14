import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/animations/delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/pages/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class LoginPage extends StatelessWidget {
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
                  child: SvgPicture.asset('assets/images/key.svg'),
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text(
                  "Welcome back ! 👋",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: d_main,
                  ),
                ),
                const SizedBox(height: 30),
                LoginForm()
              ])),
        ));
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>(); // Clé du formulaire

  // Variables pour stocker les valeurs des champs de saisie
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Champ de saisie pour l'adresse e-mail
          TextFormField(
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your e-mail address';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          // Champ de saisie pour le mot de passe
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              // Couleur de l'étiquette en sélection
            ),
            obscureText: true, // Masquer le texte du mot de passe
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
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
                    checkAccountExistence(context, _email, _password);
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
                child: const Text('Login'),
              )),
        ],
      ),
    );
  }
}

Future<void> checkAccountExistence(
    BuildContext context, String email, String keypass) async {
  final response = await http.post(
    Uri.parse('http://192.168.0.128:8080/api/user/login'),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    log("Not logged");
    // La requête a échoué. Gérez les erreurs ici.
  }
}
