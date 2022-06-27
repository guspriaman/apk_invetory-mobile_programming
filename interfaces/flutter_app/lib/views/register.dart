import 'package:flutter/material.dart';
import 'package:flutter_app/views/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/navdrawer.dart';
import '../constant.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var loading = false;
  TextEditingController namaController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Buat Akun'),
      ),
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namaController,
                        autofocus: true,
                        decoration: new InputDecoration(
                            hintText: "Nama",
                            labelText: "Nama Lengkap",
                            icon: Icon(Icons.people)),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: new InputDecoration(
                            hintText: "Username",
                            labelText: "Username akun",
                            icon: Icon(Icons.key)),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: new InputDecoration(
                            hintText: "Password",
                            labelText: "Password akun",
                            icon: Icon(Icons.password)),
                      ),
                      ElevatedButton(
                        child: Text(
                          "Daftar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // setState(() {
                          //   loading = true;
                          // });

                          var url = Uri.parse(
                              "http://${host}/flutter-api/?action=register");

                          var body = {
                            "nama": namaController.text,
                            "username": usernameController.text,
                            "password": passwordController.text
                          };

                          var response = await http.post(url,
                              headers: {
                                'Content-Type': 'application/json',
                                'Accept': 'application/json'
                              },
                              body: jsonEncode(body));

                          print('response body');
                          print(response.body);

                          var jsonResponse = jsonDecode(response.body);
                          print('decoded response');
                          print(jsonResponse);

                          if (response.statusCode == 200) {
                            var _prefs = await SharedPreferences.getInstance();
                            _prefs.setString(
                                'token', jsonResponse['data']['token']);
                            _prefs.setString(
                                'nama', jsonResponse['data']['nama']);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(jsonResponse['message']),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          } else if (response.statusCode == 422) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(jsonResponse['message']),
                            ));
                          } else {
                            print(jsonResponse);
                            print(
                                'Request failed with status: ${response.statusCode}.');
                          }
                          // setState(() {
                          //   loading = false;
                          // });
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
