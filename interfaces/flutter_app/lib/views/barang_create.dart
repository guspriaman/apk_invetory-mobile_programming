import 'package:flutter/material.dart';
import 'package:flutter_app/views/barang.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navdrawer.dart';
import '../constant.dart';

class BarangCreate extends StatefulWidget {
  BarangCreate({Key? key}) : super(key: key);

  @override
  State<BarangCreate> createState() => _BarangCreateState();
}

class _BarangCreateState extends State<BarangCreate> {
  final _formKey = GlobalKey<FormState>();
  var loading = false;
  var _jenis = -1;
  TextEditingController namaController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Tambah barang'),
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
                              "http://${host}/flutter-api/?action=barang_create");

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
