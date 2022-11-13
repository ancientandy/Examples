import 'package:flutter/material.dart';
import 'polygon_test.dart';
import 'dart:developer' as debug;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polygon Demo',
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
      home: const MyHomePage(title: 'Polygon Render Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;
  int _downCounter = 0;
  int _upCounter = 0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
      debug.log("Enter: $_enterCounter");
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      _exitCounter++;
      debug.log("Exit $_exitCounter");
    });
  }

  void _updatePosition(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
      debug.log("Pos X: $x, Y: $y");
    });
  }

  void _incrementPressed(PointerEvent details) {
    _updatePosition(details);
    setState(() {
      _downCounter++;
      debug.log("Pressed");
    });
  }

  void _incrementReleased(PointerEvent details) {
    _updatePosition(details);
    setState(() {
      _upCounter++;
      debug.log("Released");
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Listener(
        onPointerDown: _incrementPressed,
        onPointerMove: _updatePosition,
        onPointerUp: _incrementReleased,
        child: MouseRegion(
          onEnter: _incrementEnter,
          onHover: _updatePosition,
          onExit: _incrementExit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.blueAccent,
            child: LayoutBuilder(
              builder: (_, constraints) => Container(
                width: constraints.widthConstraints().maxWidth,
                height: constraints.heightConstraints().maxHeight,
                color: Colors.blueGrey,
                child: CustomPaint(
                    painter: PolygonTest(
                        constraints.widthConstraints().maxWidth,
                        constraints.heightConstraints().maxHeight)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
