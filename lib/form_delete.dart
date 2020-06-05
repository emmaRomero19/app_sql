import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form_insert.dart';
import 'form_select.dart';
import 'form_update.dart';
import 'students.dart';
import 'operation.dart';
import 'main.dart';

class formulario_delete extends StatefulWidget {
  @override
  _Delete createState() => new _Delete();
}

class _Delete extends State<formulario_delete> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerMatricula = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String matricula=null;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(matricula);
    });
  }

  void cleanData() {
    controllerMatricula.text = "";
  }

  void verificar() async{
    Student stu =
    Student(null, name, paterno, materno, phone, email, matricula);
    var col = await bdHelper.getMatricula(matricula);
    print(col);
    if (col == 0) {
      showInSnackBar("Data not found!");
      matricula=null;
      cleanData();
      refreshList();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: Colors.deepPurple, content: new Text(value, style: TextStyle(fontSize: 20.0,color: Colors.yellow),)));
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text("Delete", style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,))),
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
              )
            ],
            rows: Studentss.map((student) => DataRow(cells: [
              DataCell(IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 30.0,),
                onPressed: () {
                  bdHelper.delete(student.controlum);
                  refreshList();
                  },
              )),
              DataCell(Text(student.matricula.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.yellow))),
              DataCell(
                Text(student.name.toString(),
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.yellow)),
              ),
              DataCell(Text(student.paterno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.yellow))),
              DataCell(Text(student.materno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.yellow))),
              DataCell(Text(student.phone.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.yellow))),
              DataCell(Text(student.email.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.yellow))),
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

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "DELETE DATA SQFLite",
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
                padding: EdgeInsets.only(top:35.0, right: 15.0,bottom: 35.0,left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                      controller: controllerMatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(Icons.content_paste, size: 35.0,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      maxLength: 10,
                      validator: (val) =>
                      (val.length <10 && val.length > 1) ? 'Matricula' : null,
                      onSaved: (val) => matricula = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.tealAccent, width: 2.0)),
                          onPressed: () {
                            matricula=controllerMatricula.text;
                            if(matricula==""){
                              showInSnackBar("Data not found!");
                              matricula=null;
                              cleanData();
                              refreshList();
                            }else{
                              verificar();
                              refreshList();
                            }
                          },
                          child: Text(isUpdating ? 'Update' : 'Search Data', style: TextStyle(fontSize: 17.0),),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.tealAccent, width: 2.0)),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                            matricula=null;
                            refreshList();
                          },
                          child: Text('CANCEL', style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    ),
                    Row(children: <Widget>[ list()])
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyApp()));
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
                Icons.search,
                color: Colors.blueAccent,
                size: 28.0,
              ),
              title: Text('BUSCAR',
                  style: TextStyle(fontSize: 20.0, color: Colors.blueAccent)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => formulario_select()));
              },
            ),
          ],
        ),
      ),);
  }
}
