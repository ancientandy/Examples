import 'package:flutter/material.dart';
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
      title: 'User Tap/Mouse Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'User Tap/Mouse Input Test'),
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
  double x = 0.0;
  double y = 0.0;
  void _inputEnter(PointerEvent details) {
    debug.log("Enter");
  }

  void _inputExit(PointerEvent details) {
    debug.log("Exit");
  }

  void _inputPositionChange(PointerEvent details) {
    x = details.position.dx;
    y = details.position.dy;
    debug.log("Pos X: $x, Y: $y");
  }

  void _inputPressed(PointerEvent details) {
    _inputPositionChange(details);
    debug.log("Pressed");
  }

  void _inputReleased(PointerEvent details) {
    _inputPositionChange(details);
    debug.log("Released");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.blueAccent,
        child: Listener(
          onPointerDown: _inputPressed,
          onPointerMove: _inputPositionChange,
          onPointerUp: _inputReleased,
          child: MouseRegion(
            onEnter: _inputEnter,
            onHover: _inputPositionChange,
            onExit: _inputExit,
            child: LayoutBuilder(
              builder: (_, constraints) => Container(
                width: constraints.widthConstraints().maxWidth,
                height: constraints.heightConstraints().maxHeight,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
