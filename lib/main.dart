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
  final sensores = FirebaseDatabase.instance.ref().child("sensores");
  final estado_s1 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal1");
  final estado_s2 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal2");
  
  String data = "";
  int _counter = 0;
  String flag1 = "0";
  String flag2 = "0";
  Color _color_base1 = Colors.red; 
  Color _color_base2 = Colors.red;

  String Temperatura_s1 = "0";
  String Humedad_s1 = "0";
  String Temperatura_s2 = "0";
  String Humedad_s2 = "0";


  void addData() {
    if (flag1 == "0") {
      estado_s1.update({'enfriamiento': "1"});
      flag1 = "1";
    } else {
      estado_s1.update({'enfriamiento': "0"});
      flag1 = "0";
    }
  }

  void addData2() {
    if (flag2 == "0") {
      estado_s2.update({'enfriamiento': "1"});
      flag2 = "1";
    } else {
      estado_s2.update({'enfriamiento': "0"});
      flag2 = "0";
    }
  }


  //Imprimir desde firebase
  Future<void> PrintFromFirebase() async {
    DatabaseEvent event = await sensores.once();
    print(event.snapshot.value);
  }

  DatabaseReference t_s1 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal1").child("temperatura");
  DatabaseReference h_s1 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal1").child("humedad");
  DatabaseReference t_s2 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal2").child("temperatura");
  DatabaseReference h_s2 = FirebaseDatabase.instance.ref().child("sensores").child("sucursal2").child("humedad");

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
    Stream<DatabaseEvent> stream = t_s1.onValue;
    stream.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Temperatura_s1 = event.snapshot.value.toString();
      });
    });
    Stream<DatabaseEvent> stream1 = h_s1.onValue;
    stream1.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Humedad_s1 = event.snapshot.value.toString();
      });
    });
    Stream<DatabaseEvent> stream2 = t_s2.onValue;
    stream2.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Temperatura_s2 = event.snapshot.value.toString();
      });
    });
    Stream<DatabaseEvent> stream3 = h_s2.onValue;
    stream3.listen((DatabaseEvent event) {
      print("Event Type  ${event.type}");
      print("Este es el valor que se cambio");
      print('snapshot: ${event.snapshot.value}');
      setState(() {
        Humedad_s2 = event.snapshot.value.toString();
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
            Center(
              child: Text("Sucursal 1",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),)
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.thermostat_outlined,
                      color: Color.fromARGB(255, 57, 129, 253),
                      size: 80.0,
                      semanticLabel: "Temperatura",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Temperatura",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Temperatura_s1,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 60,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Color.fromARGB(255, 88, 255, 241),
                      size: 80.0,
                      semanticLabel: "Humedad",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Humedad",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Humedad_s1,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    setState((){
                      if (_color_base1 == Colors.red){
                        _color_base1 = Colors.green;
                        print("Encendido");
                      }else if (_color_base1 == Colors.green){
                        _color_base1 = Colors.red;
                        print("Apagado");
                      }
                      addData();
                    });
                  },
                  icon: Icon(
                    Icons.power_settings_new,
                    color : _color_base1,
                    size: 60.0,
                    semanticLabel: "On/Off"
                  )
                )
              ]
            ),
            const SizedBox(height: 80),
            Center(
              child: Text("Sucursal 2",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),)
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.thermostat_outlined,
                      color: Color.fromARGB(255, 57, 129, 253),
                      size: 80.0,
                      semanticLabel: "Temperatura",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Temperatura",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Temperatura_s2,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 60,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Color.fromARGB(255, 88, 255, 241),
                      size: 80.0,
                      semanticLabel: "Humedad",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Humedad",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        Humedad_s2,
                        style: TextStyle(color: Colors.red,
                            fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    setState((){
                      if (_color_base2 == Colors.red){
                        _color_base2 = Colors.green;
                        print("Encendido");
                      }else if (_color_base2 == Colors.green){
                        _color_base2 = Colors.red;
                        print("Apagado");
                      }
                      addData2();
                    });
                  },
                  icon: Icon(
                    Icons.power_settings_new,
                    color : _color_base2,
                    size: 60.0,
                    semanticLabel: "On/Off"
                  )
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}