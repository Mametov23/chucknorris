import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Todo/todo.dart';
import 'addtodo.dart';
import 'client/hive_names.dart';


import 'apichuck.dart';

const url = 'https://api.chucknorris.io/jokes/random';

void main() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>(HiveBoxes.todo);
    runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<void> mem;
  late String note;

  @override
  void initState() {
    super.initState();
    mem = chuckApiCall();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
                appBar: AppBar(
                  title: const Text('Chuck'),
                  centerTitle: true,
                ),
                body: FutureBuilder<Chuck>(
                  future: chuckApiCall(),
                  builder: (context, snapshot) {
                    const CircularProgressIndicator();
                    if(snapshot.hasData) {
                      return Stack(children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topCenter,
                                      child: Text("${snapshot.data!.value} ",
                                        semanticsLabel: note = snapshot.data!.value,
                                          )),
                                  // Button for refresh de App
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: ClipRRect(
                                      child: ElevatedButton(
                                        child:  const Text('Нажми'),
                                        onPressed: () {
                                          setState(() => _MyHomePageState());
                                          if (kDebugMode) {
                                            print('нажатие');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                              child: ElevatedButton(
                                child: Text('Добавить в избранное'),
                                onPressed: (){
                                  _add();
                                  print('добавленно в избранное');
                                },
                              ),
                    ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: ElevatedButton(
                                      child: Text('Избранное'),
                                      onPressed: (){
                                        print('список избранного');
                                      },
                                    ),
                                  )
                                ])
                        )]);
                    }else if (snapshot.hasError){
                      return Center(
                        child: Text('${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Center(
                      child: Center(child: CircularProgressIndicator()
                      ),
                    );
                  },
                ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddTo(title: '',))),
    tooltip: 'Add todo',
        )
    );
  }
  void _add(){
    Box<Todo> contactsBox = Hive.box<Todo>(HiveBoxes.todo);
    contactsBox.add(Todo(note: note));
  }
}

