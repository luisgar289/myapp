import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'LimpiaTIC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark(),
        home: const MyHomePage(title: 'LimpiaTIC'),
      );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textcontroller = TextEditingController();
  final sucursal1 = FirebaseDatabase.instance.ref().child("test");
  String data = "";
  int _counter = 0;
  int flag = 0;
  Color _color_base = Colors.grey; //Variable de Cambio de color

  String Temperatura = "0";
  String Humedad = "0";


  /*MÉTODOS PARA USAR FIREBASE
  void addData() {
    if (flag == 0) {
      sucursal1.set({'relay': "0"});
      flag = 1;
    } else {
      sucursal1.set({'relay': "1"});
      flag = 0;
    }
  }
  */
  //Imprimir desde firebase
  Future<void> PrintFromFirebase() async {
    DatabaseEvent event = await sucursal1.once();
    print(event.snapshot.value);
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref().child("test").child("temperatura");
  DatabaseReference ref1 = FirebaseDatabase.instance.ref().child("test").child("humedad");

  /*****************************************************/
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("On message: $message");
      showOverlayNotification((context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: ListTile(
              leading: SizedBox.fromSize(
                size: const Size(40.0, 40.0),
                child: ClipOval(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(message.notification!.title!),
              subtitle: Text(message.notification!.body!),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                },
              ),
            ),
          ),
        );
      }, duration: const Duration(milliseconds: 4000));
      print(message.notification!.title);
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Nueva notificación con la App Abierta");
        Navigator.pushNamed(context, '/message');
      });
    });
    super.initState();
    Stream<DatabaseEvent> stream = ref.onValue;
    stream.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Temperatura = event.snapshot.value.toString();
      });
    });
    Stream<DatabaseEvent> stream1 = ref1.onValue;
    stream1.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Humedad = event.snapshot.value.toString();
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOn = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      Container (
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Sucursal 1",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.thermostat_outlined,
                      color: Color.fromARGB(255, 117, 168, 255),
                      size: 80.0,
                      semanticLabel: "Temperatura",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Temperatura"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Temperatura,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Color.fromARGB(255, 117, 168, 255),
                      size: 80.0,
                      semanticLabel: "Humedad",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Humedad"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Humedad,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Cerrar"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "Sucursal 2",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.thermostat_outlined,
                      color: Color.fromARGB(255, 117, 168, 255),
                      size: 80.0,
                      semanticLabel: "Temperatura",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Temperatura"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Temperatura,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Color.fromARGB(255, 117, 168, 255),
                      size: 80.0,
                      semanticLabel: "Humedad",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Humedad"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Humedad,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("Cerrar"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}