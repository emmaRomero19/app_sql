import 'package:appsql/form_select.dart';
import 'package:appsql/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'convert.dart';
import 'form_delete.dart';
import 'form_update.dart';
import 'students.dart';
import 'operation.dart';
import 'dart:async';
import 'form_insert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPaterno = TextEditingController();
  TextEditingController controllerMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(null);
    });
  }

  void cleanData() {
    controllerName.text = "";
    controllerPaterno.text = "";
    controllerMaterno.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerMatricula.text = "";
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
              Navigator.push(
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
              Navigator.push(context,
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
              Navigator.push(context,
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
              Navigator.push(context,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => formulario_select()));
            },
          ),

        ],
      ),
    );
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "Control",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
              DataColumn(
                label: Text("Matricula",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(
                label: Text("Name",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(
                label: Text("Paterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(
                label: Text("Materno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(
                label: Text("Phone",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
              ),
              DataColumn(label: Text("Photo",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent)),)
            ],
            rows: Studentss.map((student) => DataRow(cells: [
                  DataCell(Text(student.controlum.toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow))),
                  DataCell(Text(student.matricula.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange))),
                  DataCell(
                    Text(student.name.toString(),
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.deepOrange)),
                  ),
                  DataCell(Text(student.paterno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange))),
                  DataCell(Text(student.materno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange))),
                  DataCell(Text(student.phone.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange))),
                  DataCell(Text(student.email.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange))),
                  DataCell(Convertir.imageFromBase64sString(student.photo),
                  ),
                ])).toList(),
          ),
        ));
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        backgroundColor: Colors.deepPurple,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Center(
                    child: Container(
                        padding: EdgeInsets.all(15.0),
                        width: MediaQuery.of(context).size.width,
                        child: MaterialButton(
                          color: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.deepPurple, width: 5.0)),
                          onPressed: refreshList,
                          child: Text(
                            'UPDATE',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        )))
              ],
            ),
            list(),
            //NavDrawer(),
          ],
        ),
      ),
    );
  }
}
