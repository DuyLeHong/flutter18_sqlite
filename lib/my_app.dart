

import 'package:flutter/material.dart';
import 'package:flutter18_sqlite/sqlite_controller.dart';

import 'dog_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SQLiteController sqliteController;
  late List<Dog> _dogs = [];

  @override
  void initState() {
    super.initState();

    sqliteController = SQLiteController();

    getListDogsFirstTime();
  }

  void getListDogsFirstTime() async {
    await sqliteController.initializeDatabase();
    getListDogs();
  }

  void getListDogs() async {
    _dogs.clear();
    _dogs = await sqliteController.dogs();

    _counter = _dogs.length;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    String sDogs = '';

    for (Dog dog in _dogs) {
      sDogs += dog.toString2();
      sDogs += '\n';
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'List dogs:',
            ),
            Text(
              sDogs,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () async {

                  _counter++;
                  Dog fido = Dog(name: 'Fido$_counter', age: 35);
                  await sqliteController.insertDog(fido);
                  getListDogs();

                  setState(() {

                  });
                },
                // add event <=== new
                child: Icon(Icons.plus_one),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () async {

                  Dog fido = Dog(name: 'Fido$_counter', age: 35);
                  await sqliteController.deleteDog(fido.name);
                  _counter--;
                  getListDogs();

                  setState(() {

                  });
                },
                // add event <=== new
                child: Icon(Icons.exposure_minus_1),
              )
            ],
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}