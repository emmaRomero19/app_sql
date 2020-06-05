import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form_delete.dart';
import 'form_insert.dart';
import 'form_select.dart';
import 'form_update.dart';
import 'students.dart';
import 'operation.dart';
import 'main.dart';

class formulario_update extends StatefulWidget {
  @override
  _Update createState() => new _Update();
}

class _Update extends State<formulario_update> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerValue = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula = null;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  int opcion;
  String valor;

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
    controllerValue.text = "";
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.deepPurple,
        content: new Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.yellow),
        )));
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
                label: Text("Email",
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
              )
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
                      onTap: () {
                        setState(() {
                          //isUpdating = true;
                          currentUserId = student.controlum;
                          name = student.name;
                          paterno = student.paterno;
                          materno=student.materno;
                          phone=student.phone;
                          email=student.email;
                          matricula=student.matricula;
                          opcion=1;
                        });
                        controllerValue.text = student.name;
                      }
                  ),
                  DataCell(Text(student.paterno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange)), onTap: () {
                    setState(() {
                      //isUpdating = true;
                      currentUserId = student.controlum;
                      name = student.name;
                      paterno = student.paterno;
                      materno=student.materno;
                      phone=student.phone;
                      email=student.email;
                      matricula=student.matricula;
                      opcion=2;
                    });
                    controllerValue.text = student.paterno;
                  }),
                  DataCell(Text(student.materno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange)), onTap: () {
                    setState(() {
                      //isUpdating = true;
                      currentUserId = student.controlum;
                      name = student.name;
                      paterno = student.paterno;
                      materno=student.materno;
                      phone=student.phone;
                      email=student.email;
                      matricula=student.matricula;
                      opcion=3;
                    });
                    controllerValue.text = student.materno;
                  }),
                  DataCell(Text(student.phone.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange)), onTap: () {
                    setState(() {
                      //isUpdating = true;
                      currentUserId = student.controlum;
                      name = student.name;
                      paterno = student.paterno;
                      materno=student.materno;
                      phone=student.phone;
                      email=student.email;
                      matricula=student.matricula;
                      opcion=4;
                    });
                    controllerValue.text = student.phone;
                  }),
                  DataCell(Text(student.email.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.deepOrange)), onTap: () {
                    setState(() {
                      //isUpdating = true;
                      currentUserId = student.controlum;
                      name = student.name;
                      paterno = student.paterno;
                      materno=student.materno;
                      phone=student.phone;
                      email=student.email;
                      matricula=student.matricula;
                      opcion=5;
                    });
                    controllerValue.text = student.email;
                  }),
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

  void updateData() {
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if(opcion == null){
        bdHelper.getStudents(matricula);
      }
      else if (opcion == 1) {
        Student stu = Student(
            currentUserId, valor, paterno, materno, phone, email, matricula);
        bdHelper.update(stu);
      } else if (opcion == 2) {
        Student stu = Student(
            currentUserId, name, valor, materno, phone, email, matricula);
        bdHelper.update(stu);
      } else if (opcion == 3) {
        Student stu = Student(
            currentUserId, name, paterno, valor, phone, email, matricula);
        bdHelper.update(stu);
      } else if (opcion == 4) {
        Student stu = Student(
            currentUserId, name, paterno, materno, valor, email, matricula);
        bdHelper.update(stu);
      } else if (opcion == 5) {
        Student stu = Student(
            currentUserId, name, paterno, materno, phone, valor, matricula);
        bdHelper.update(stu);
      }
    }
    cleanData();
    refreshList();
  }

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "UPDATE DATA SQFLite",
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 35.0, right: 15.0, bottom: 35.0, left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerValue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Change value',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.autorenew,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese nuevo valor' : null,
                      onSaved: (val) => valor = val.toUpperCase(),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors.tealAccent, width: 2.0)),
                            onPressed: () {
                              updateData();
                              refreshList();
                              opcion=null;
                            },
                            child: Text(
                              isUpdating ? 'Update' : 'Update',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(children: <Widget>[list()])
                  ],
                ),
              ),
            ),
          )),
      endDrawer: new Drawer(
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
              leading: Icon(
                Icons.home,
                color: Colors.deepPurple,
                size: 28.0,
              ),
              title: Text(
                'HOME',
                style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => formulario_update()));
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => formulario_insert()));
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => formulario_delete()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.blueAccent,
                size: 28.0,
              ),
              title: Text('BUSCAR',
                  style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => formulario_select()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
