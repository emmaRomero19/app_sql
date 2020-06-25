import 'package:appsql/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form_delete.dart';
import 'form_select.dart';
import 'form_update.dart';
import 'students.dart';
import 'operation.dart';
import 'package:image_picker/image_picker.dart';
import 'convert.dart';

class formulario_insert extends StatefulWidget {
  @override
  _Insert createState() => new _Insert();
}

class _Insert extends State<formulario_insert> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPaterno = TextEditingController();
  TextEditingController controllerMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  String name;
  String paterno;
  String materno;
  String email;
  String phone;
  String image;
  String matricula=null;
  String photo;
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
    controllerName.text = "";
    controllerPaterno.text = "";
    controllerMaterno.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerMatricula.text = "";
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: Colors.deepPurple, content: new Text(value, style: TextStyle(fontSize: 20.0,color: Colors.yellow),)));
  }

  void verificar() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(
            currentUserId, name, paterno, materno, phone, email, matricula, image);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu =
            Student(null, name, paterno, materno, phone, email, matricula, image);
        var col = await bdHelper.getMatricula(matricula);
        print(col);
        if (col == 0) {
          bdHelper.insert(stu);
          showInSnackBar("Data saved");
        } else {
          showInSnackBar("Error! Ya existe esta matricula");
        }
      }
      cleanData();
      refreshList();
    }
  }

  ImageGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  ImageCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  //Select the image
  Future<void> _selectphoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Make a choise!", textAlign: TextAlign.center,),
              backgroundColor: Colors.deepPurpleAccent[200],
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      ImageGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0),),
                  GestureDetector(
                    child: Text("Camera",),
                    onTap: () {
                      ImageCamera(context );
                    },
                  )
                ]),
              ));
        });
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


  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text(
          "INSERT DATA SQFLite",
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
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
                    TextFormField(
                      controller: controllerPhoto,
                      decoration: InputDecoration(
                          labelText: "Photo",
                          suffixIcon: RaisedButton(
                            color: Colors.deepPurple[200],
                            onPressed: () {
                              _selectphoto(context);
                            },
                            child: Text("Select image", textAlign: TextAlign.center,),
                          )),
                      validator: (val) => val.length == 0
                          ? 'Debes subir una imagen'
                          : controllerPhoto.text == "Campo lleno"
                          ? null
                          : "Solo imagenes",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: controllerName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) => val.length == 0 ? 'Enter name' : null,
                      onSaved: (val) => name = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerPaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Paternal Surname',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_outline,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => paterno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerMaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Maternal Surname',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_outline,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => materno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.mail,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(val)
                              ? 'Enter mail'
                              : null,
                      onSaved: (val) => email = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.phone,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      maxLength: 10,
                      validator: (val) =>
                          val.length < 10 ? 'Enter phone number' : null,
                      onSaved: (val) => phone = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerMatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.content_paste,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      maxLength: 10,
                      validator: (val) =>
                          (val.length < 10) ? 'Matricula' : null,
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
                              side: BorderSide(
                                  color: Colors.tealAccent, width: 2.0)),
                          onPressed: () async {
                            verificar();
                          },
                          child: Text(
                            isUpdating ? 'Update' : 'Add Data',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.tealAccent, width: 2.0)),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                          },
                          child:
                              Text('CANCEL', style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
