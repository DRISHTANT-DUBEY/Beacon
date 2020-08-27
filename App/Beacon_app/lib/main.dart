import 'package:Beacon_app/UI/Intray/intray_page.dart';
import 'package:Beacon_app/UI/Login/loginscreen.dart';
import 'package:Beacon_app/bloc/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/global.dart';
import 'package:http/http.dart' as http;
import 'package:Beacon_app/models/classes/user.dart';
import 'package:Beacon_app/bloc/blocs/user_bloc_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beacon',
        theme: ThemeData(
            primarySwatch: Colors.grey,
            dialogBackgroundColor: Colors.transparent),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TaskBloc tasksBloc;
  String apiKey = "";
  Repository _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signinUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          apiKey = snapshot.data;
          tasksBloc = TaskBloc(apiKey);
          print(apiKey);
        } else {
          print("No data");
        }
        // String apiKey = snapshot.data;
        //apiKey.length > 0 ? getHomePage() :
        return apiKey.length > 0
            ? getHomePage()
            : LoginPage(
                login: login,
                newUser: false,
              );
      },
    );
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  Future signinUser() async {
    String userName = "";
    String apiKey = await getApiKey();
    if (apiKey.length > 0) {
      userBloc.signinUser("", "", apiKey);
    } else {
      print("No Api key Found");
    }
    return apiKey;
  }

  Future getApiKey() async {
    print("hello");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString("API_Token");
  }

  Widget getHomePage() {
    return MaterialApp(
      color: Colors.yellow,
      home: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: new Scaffold(
            body: Stack(children: <Widget>[
              TabBarView(
                children: [
                  new Container(
                    color: blueColor,
                  ),
                  IntrayPage(
                    apiKey: apiKey,
                  ),
                  new Container(
                    child: Center(
                      child: FlatButton(
                        color: Colors.orangeAccent[700],
                        child: Text("Log out"),
                        onPressed: () {
                          logout();
                        },
                      ),
                    ),
                    color: blueColor,
                  ),
                ],
              ),
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      "Intray",
                      style: intrayTitleStyle,
                    )),
                    Container(),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 80,
                margin: EdgeInsets.only(
                    top: 120, left: MediaQuery.of(context).size.width * 0.75),
                child: Container(
                  height: 80,
                  width: 80,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      size: 70,
                    ),
                    backgroundColor: Colors.orange[400],
                    onPressed: _additionmenubox,
                  ),
                ),
              ),
            ]),
            appBar: AppBar(
              elevation: 0,
              title: new TabBar(
                tabs: [
                  Tab(
                    icon: new Icon(Icons.calendar_today, size: 55),
                  ),
                  Tab(
                    icon: new Icon(Icons.add, size: 60),
                  ),
                  Tab(
                    icon: new Icon(Icons.menu, size: 60),
                  ),
                ],
                labelColor: blueColor,
                unselectedLabelColor: greylightColor,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.transparent,
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _additionmenubox() {
    TextEditingController taskName = new TextEditingController();
    TextEditingController deadline = new TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints.expand(height: 900, width: 690),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[200], Colors.grey[300]]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Adder", style: intrayTitleStyle),
                Container(
                  child: FlatButton(
                    color: Colors.transparent,
                    child: Text(
                      " Tasks ",
                      style: additionMenuStyle,
                    ),
                    onPressed: _showAddDialog,
                  ),
                ),
                Container(
                  child: FlatButton(
                    color: Colors.transparent,
                    child: Text(
                      " Meets ",
                      style: additionMenuStyle,
                    ),
                    onPressed: _showAddDialog,
                  ),
                ),
                Container(
                  child: FlatButton(
                    color: Colors.transparent,
                    child: Text(
                      " Reminders ",
                      style: additionMenuStyle,
                    ),
                    onPressed: _showAddDialog,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.cancel,
                      size: 50,
                    ),
                    backgroundColor: Colors.grey[400],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog() {
    TextEditingController taskName = new TextEditingController();
    TextEditingController deadline = new TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints.expand(height: 900, width: 690),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[200], Colors.grey[300]]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Tasks", style: intrayTitleStyle,),
                Text(" Task Name ", style: additionMenuStyle),
                Container(
                  child: TextField(
                    autofocus: false,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22.0,
                        color: blueColor,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Task Name',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    controller: taskName,
                  ),
                ),
                Text(" Deadline ", style: additionMenuStyle),
                Container(
                  child: TextField(
                    autofocus: false,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22.0,
                        color: blueColor,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Task Name',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    controller: deadline,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.transparent,
                      child: Text(
                        " Cancel ",
                        style: additionbuttonStyle,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: Colors.transparent,
                      child: Text(
                        " Add ",
                        style: additionbuttonStyle,
                      ),
                      onPressed: () {
                        if (taskName.text != null) {
                          addTask(taskName.text, deadline.text);
                          Navigator.pop(context);}
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void addTask(String taskName, String deadline) async {
    await _repository.addUserTask(this.apiKey, taskName, deadline);
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("API_Token", "");
    setState(() {
      build(context);
    });
  }

  @override
  void initState() {
    super.initState();
  }
}
