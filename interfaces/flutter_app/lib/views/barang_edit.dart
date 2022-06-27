// ignore_for_file: unnecessary_this, prefer_typing_uninitialized_variables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_app/views/barang.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navdrawer.dart';
import '../constant.dart';

class BarangEdit extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final nama;
  // ignore: prefer_typing_uninitialized_variables
  final jenis;
  final id;
  const BarangEdit(
      {Key? key, required this.nama, required this.jenis, required this.id})
      : super(key: key);

  @override
  State<BarangEdit> createState() =>
      // ignore: no_logic_in_create_state
      _BarangEditState(nama: this.nama, jenis: this.jenis, id: this.id);
}

class _BarangEditState extends State<BarangEdit> {
  final _formKey = GlobalKey<FormState>();
  var loading = false;
  var _jenis = -1;
  final nama;
  final jenis;
  final id;

  _BarangEditState({required this.nama, required this.jenis, required this.id});

  TextEditingController namaController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    namaController.text = nama;
    switch (jenis) {
      case "peripheral":
        _jenis = 1;
        break;
      case "sparepart":
        _jenis = 2;
        break;
            case "atk":
        _jenis = 3;
        break;
      default:
        _jenis = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Ubah barang'),
      ),
      body: Container(
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
                            hintText: "Nama Barang",
                            labelText: "Nama barang",
                            icon: Icon(Icons.people)),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Jenis Barang',
                            textAlign: TextAlign.start,
                          ),
                          ListTile(
                            title: const Text('Peripheral'),
                            leading: Radio(
                              value: 1,
                              groupValue: _jenis,
                              onChanged: (value) {
                                setState(() {
                                  _jenis = value as int;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Sparepart'),
                            leading: Radio(
                              value: 2,
                              groupValue: _jenis,
                              onChanged: (value) {
                                setState(() {
                                  _jenis = value as int;
                                });
                              },
                            ),
                          ),
                           ListTile(
                            title: const Text('Alat Tulis Kantor'),
                            leading: Radio(
                              value: 3,
                              groupValue: _jenis,
                              onChanged: (value) {
                                setState(() {
                                  _jenis = value as int;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        child: Text(
                          "Tambah",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          var _prefs = await SharedPreferences.getInstance();
                          var token = _prefs.getString("token");
                          var url = Uri.parse(
                              "http://${host}/flutter-api/?action=barang_update&id=$id");

                          var jenisRendered = "";
                          switch (_jenis) {
                            case 1:
                              jenisRendered = "peripheral";
                              break;
                            case 2:
                              jenisRendered = "sparepart";
                              break;
                            case 3:
                              jenisRendered = "atk";
                              break;
                            default:
                              jenisRendered = "";
                          }

                          var body = {
                            "nama": namaController.text,
                            "jenis": jenisRendered
                          };

                          print(body);

                          var response = await http.post(url,
                              headers: {
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': "Bearer $token"
                              },
                              body: jsonEncode(body));

                          print('create barang response body');
                          print(response.body);

                          var jsonResponse = jsonDecode(response.body);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(jsonResponse['message']),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Barang()));
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
