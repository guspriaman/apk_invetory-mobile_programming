import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/views/barang_create.dart';
import 'package:flutter_app/views/barang_edit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/navdrawer.dart';

class Barang extends StatefulWidget {
  Barang({Key? key}) : super(key: key);

  @override
  State<Barang> createState() => _BarangState();
}

class _BarangState extends State<Barang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: Container(
        child: FutureBuilder<List<BarangModel>>(
          future: _fetchBarang(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BarangModel>? data = snapshot.data;
              return _BarangListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BarangCreate()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<BarangModel>> _fetchBarang() async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');

    final jobsListAPIUrl =
        Uri.parse("http://$host/flutter-api/?action=barang_json");
    final response = await http.get(jobsListAPIUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer ${token}"
    });

    List<dynamic> decodedResponse = jsonDecode(response.body)['data'];
    print(decodedResponse);
    return decodedResponse
        .map((barang) => new BarangModel.fromJson(barang))
        .toList();
  }

  ListView _BarangListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].nama, data[index].jenis, data[index]);
        });
  }

  ListTile _tile(String title, String subtitle, BarangModel barang) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BarangEdit(
                            id: barang.id,
                            nama: barang.nama,
                            jenis: barang.jenis,
                          )));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: () async {
              var _prefs = await SharedPreferences.getInstance();
              var token = _prefs.getString("token");
              var url = Uri.parse(
                  "http://${host}/flutter-api/?action=barang_destroy&id=${barang.id}");

              var response = await http.post(url, headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': "Bearer $token"
              });

              print('delete barang response');
              print(response.body);

              var jsonResponse = jsonDecode(response.body);

              if (response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(jsonResponse['message']),
                ));
                setState(() {});
              } else if (response.statusCode == 422) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(jsonResponse['message']),
                ));
              } else {}
              //   _onDeleteItemPressed(index);
            },
          ),
        ],
      ));
}

class BarangModel {
  final String id;
  final String nama;
  final String jenis;

  BarangModel({required this.id, required this.nama, required this.jenis});

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return BarangModel(
        id: json['id'], nama: json['nama'], jenis: json['jenis']);
  }
}
