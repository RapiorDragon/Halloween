import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Spooky Halloween Website'),
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
  List<bool> listOfVisibility = List.filled(16, true);
  int _counter = 0;
  int _score = 0;

  final player = AudioPlayer();

  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void addTime() {
    setState(
      () {
        int seconds = duration.inSeconds + 1;
        duration = Duration(seconds: seconds);
      },
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  // Sometimes timer speeds up ??
  void show() {
    Random random = Random();
    var time = const Duration(seconds: 3);
    Timer.periodic(
      time,
      (timer) {
        int i = random.nextInt(15);
        setState(
          () {
            listOfVisibility[i] = !listOfVisibility[i];
          },
        );
      },
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      if (_counter == 10) {
        player.play(DeviceFileSource('assets/Happy Halloween!.mp3'));
      }
    });
  }

  String displayCounter() {
    if (_counter < 10) {
      return "$_counter";
    } else {
      return "Happy Halloween!";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> LemonTable = [
      buildLemonColumn([0, 1, 2, 3]),
      buildLemonColumn([4, 5, 6, 7]),
      buildLemonColumn([8, 9, 10, 11]),
      buildLemonColumn([12, 13, 14, 15]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            buildTime(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: LemonTable,
            ),
            buildButtonPress(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Column(
      children: [
        const Text('Timer', style: TextStyle(fontSize: 60)),
        Text(
          '$minutes: $seconds',
          style: const TextStyle(fontSize: 40),
        ),
      ],
    );
  }

  Widget buildLemonColumn(List nums) {
    return Column(
      children: [
        buildImage(context, listOfVisibility[nums[0]]),
        buildImage(context, listOfVisibility[nums[1]]),
        buildImage(context, listOfVisibility[nums[2]]),
        buildImage(context, listOfVisibility[nums[3]]),
      ],
    );
  }

  Widget buildButtonPress() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Incremental Button Presses: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Palatino',
                ),
              ),
              Text(displayCounter()),
            ],
          )),
    );
  }

  Widget buildImage(BuildContext context, bool isVisible) {
    show();

    return Visibility(
      visible: isVisible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: IconButton(
        splashRadius: 50,
        iconSize: 75,
        icon: Ink.image(
          image: const AssetImage('assets/Lemon.png'),
        ),
        onPressed: () {
          _score++;
          debugPrint("Score: $_score");
          player.play(DeviceFileSource('assets/Oof.mp3'));
        },
      ),
    );
  }
}
