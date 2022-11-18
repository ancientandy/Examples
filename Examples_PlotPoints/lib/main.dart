import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer' as debug;
import 'constants.dart' as constants;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'points.dart';

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
      title: 'Plot and Store Points',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Plot and Store Points'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _x = 0.0;
  double _y = 0.0;
  String _focusText = constants.outside;
  String _pressedText = constants.notPressed;
  GlobalKey key = GlobalKey();
  Points points = Points();

  void _inputEnter(PointerEvent details) {
    setState(() {
      _focusText = constants.inside;
      debug.log(_focusText);
    });
  }

  void _inputExit(PointerEvent details) {
    setState(() {
      _focusText = constants.outside;
      debug.log(_focusText);
    });
  }

  void _inputPositionChange(PointerEvent details) {
    setState(() {
      // Get the offset (from TL) of the container
      RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
      Offset pos = box.localToGlobal(Offset.zero);

      // Set the X and Y relative to the container TL
      _x = details.position.dx - pos.dx;
      _y = details.position.dy - pos.dy;
      debug.log("Pos X: $_x, Y: $_y");
    });
  }

  void _inputPressed(PointerEvent details) {
    setState(() {
      _inputPositionChange(details);
      _pressedText = constants.pressed;
      debug.log(_pressedText);

      _storePosition(_x, _y);
    });
  }

  void _inputReleased(PointerEvent details) {
    setState(() {
      _inputPositionChange(details);
      _pressedText = constants.notPressed;
      debug.log(_pressedText);
    });
  }

  void _storePosition(double x, double y) {
    _saveAsync();
  }

  void _saveAsync() async {
    // Add a point to the list
    points.add(_x, _y, 0.0);

    // Convert to json
    String json = jsonEncode(points);

    // Convert from json
    Map<String, dynamic> map = jsonDecode(json);

    final directory =
        await getApplicationDocumentsDirectory(); // Can't use this with web... DB?
    final File file = File('${directory.path}/jsonObjects.json');
    debug.log(file.path);

    // if (await file.exists()) {
    //   json = await file.readAsString();
    // } else {
    file.writeAsString(json);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    const margin = EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Column(children: [
            Expanded(
              flex: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.blueAccent,

                /// The listener listens for various events. We're using it to
                /// track the user PointerDown and PointerUp (Mouse click or
                /// screen tap)
                child: Listener(
                  onPointerDown: _inputPressed,
                  onPointerMove: _inputPositionChange,
                  onPointerUp: _inputReleased,

                  /// Track mouse focus events and position changes
                  /// Tapping doesn't really have a focus as it's either inside
                  /// or nothing is happening
                  child: MouseRegion(
                    onEnter: _inputEnter,
                    onHover: _inputPositionChange,
                    onExit: _inputExit,
                    child: LayoutBuilder(
                      builder: (_, constraints) => Container(
                        key: key,
                        width: constraints.widthConstraints().maxWidth,
                        height: constraints.heightConstraints().maxHeight,
                        color: Colors.blueGrey,
                        child: Stack(children: [
                          /// Add a transform to show the mouse/tap position
                          Transform(
                              transform: Matrix4.translationValues(
                                  _x - 16, _y - 16, 0.0),
                              child: const CircleAvatar(
                                radius: 16,
                              ))
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Update the area at the bottom of the screen where we show the
            /// stats and feedback on what's going on
            Expanded(
              flex: 1,
              child: Container(
                  width: width,
                  margin: margin, //variable
                  color: const Color.fromARGB(255, 10, 40, 53), //variable
                  child: Text(
                      "X: ${_x.toStringAsFixed(4)}, Y: ${_y.toStringAsFixed(4)}\nFocus: $_focusText\nButton/Tap: $_pressedText",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)))),
            )
          ]),
        ));
  }
}
