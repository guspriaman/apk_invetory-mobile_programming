import 'package:flutter/material.dart';
import 'package:flutter_app/views/barang.dart';
import 'package:flutter_app/views/home.dart';
import 'package:flutter_app/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/register.dart';

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
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
    print("navbar");
    print("token : ${token}");
    print("nama : ${nama}");
    return Drawer(
        child: token == null || token == false ? guestMenu() : userMenu());
  }

  guestMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'INVENTORI PT SEJAHTERA ABADI',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()))
          },
        ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Login'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()))
          },
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text('Daftar'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()))
          },
        ),
      ],
    );
  }

  userMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            "Selamat datang : ${nama}",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()))
          },
        ),
        ListTile(
          leading: Icon(Icons.dataset),
          title: Text('Daftar Barang'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Barang()))
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            var _prefs = await SharedPreferences.getInstance();
            _prefs.remove('nama');
            _prefs.remove('token');
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            });
          },
        ),
      ],
    );
  }
}
