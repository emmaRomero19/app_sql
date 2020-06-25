import 'package:flutter/cupertino.dart';

import 'form_delete.dart';
import 'form_insert.dart';
import 'form_select.dart';
import 'form_update.dart';
import 'operation.dart';
import 'details.dart';
import 'students.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'convert.dart';
//import 'detalles.dart';

class busqueda extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<busqueda> {
  //ELEMENTOS PARA BUSCAR
  String searchString = "";
  bool _isSearching = false;

  Future<List<Student>> Studentss;
  var bdHelper;
  TextEditingController searchController = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula;
  String photo;
  String image;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    _isSearching = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.select(searchController.text);
    });
  }

  void cleanData() {
    searchController.text = "";
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(50.0),
            child: Text(
              "MENU",
              style: TextStyle(color: Colors.white, fontSize: 55),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(color: Colors.deepPurple),
          ),
          ListTile(
            leading: Icon(Icons.content_paste, size: 28.0, color: Colors.deepPurpleAccent),
            title: Text('BUSCAR', style: TextStyle(fontSize: 20.0, color: Colors.deepPurple)),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => busqueda()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.update,
              color: Colors.yellowAccent,
              size: 28.0,
            ),
            title: Text(
              'UPDATE',
              style: TextStyle(fontSize: 20.0, color: Colors.yellowAccent),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => formulario_update()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.greenAccent,
              size: 28.0,
            ),
            title: Text('INSERT',
                style: TextStyle(fontSize: 20.0, color: Colors.greenAccent)),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => formulario_insert()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Colors.red[800],
              size: 28.0,
            ),
            title: Text('ELIMINAR',
                style: TextStyle(fontSize: 20.0, color: Colors.red[800])),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => formulario_delete()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.location_searching,
              color: Colors.blue[800],
              size: 28.0,
            ),
            title: Text('SELECT',
                style: TextStyle(fontSize: 20.0, color: Colors.blue[800])),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => formulario_select()));
            },
          ),

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      drawer: menu(),
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: _isSearching
            ? TextField(
                decoration: InputDecoration(hintText: "Buscando..."),
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                },
                controller: searchController,
              )
            : Text(
                "BUSCAR",
                style: TextStyle(color: Colors.white),
              ),
        actions:  <Widget>[
          !_isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      searchString = "";
                      this._isSearching = !this._isSearching;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      this._isSearching = !this._isSearching;
                    });
                  },
                ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: Studentss,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando información..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].matricula
                            .contains(searchController.text)
                        ? ListTile(
                            leading: CircleAvatar(
                              minRadius: 30.0,
                              maxRadius: 30.0,
                              backgroundColor: Colors.black,
                              backgroundImage: Convertir.imageFromBase64sString(
                                      snapshot.data[index].photo)
                                  .image,
                            ),
                            title: new Text(
                              snapshot.data[index].matricula
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow
                              ),
                            ),
                            subtitle: new Text(
                              snapshot.data[index].name
                                  .toString()
                                  .toUpperCase() +" "+ snapshot.data[index].paterno
                                  .toString()
                                  .toUpperCase()+ " " + snapshot.data[index].materno
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.deepOrange
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(snapshot.data[index])));
                            },
                          )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),

    );
  }
}
