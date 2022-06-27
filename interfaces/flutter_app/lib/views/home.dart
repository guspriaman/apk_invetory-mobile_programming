import 'package:flutter/material.dart';
import 'package:flutter_app/components/navdrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var token = null, nama = null;

  @override
  void initState() {
    //the listener for up and down.
    super.initState();
    SharedPreferences.getInstance().then((prefValue) => {
          setState(() {
            nama = prefValue.getString('nama') ?? false;
            token = prefValue.getString('token');
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('INVENTORI PT SEJAHTERA ABADI'),
        ),
        body: Center(
            child: token == null || token == false
                ? Text('Silahkan login untuk memulai sesi')
                : Text('Selamat datang ${nama}')));
  }
}
