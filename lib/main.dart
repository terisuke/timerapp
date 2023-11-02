import 'dart:async';
import 'next_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Timer app'),
      ),
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
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  int _millisecond = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/EDOWhCtU8AA9Pvs.jpg'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTimeUnit("h", _hour, 2),
                SizedBox(width: 10.w),
                const Text(":"),
                buildTimeUnit("min", _minute, 2),
                SizedBox(width: 10.w),
                const Text(":"),
                buildTimeUnit("sec", _second, 2),
                SizedBox(width: 10.w),
                const Text(":"),
                buildTimeUnit("milli", _millisecond, 3),
              ],
            ),
            ElevatedButton(
              onPressed: toggleTimer,
              child: Text(
                _isRunning ? 'Stop' : 'Start',
                style: TextStyle(
                  color: _isRunning ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: ResetTimer,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeUnit(String label, int value, int padding) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.sp,
          ),
        ),
        Text(
          value.toString().padLeft(padding, '0'),
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 100.w / padding,
          ),
        ),
      ],
    );
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      if (_second == 10) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NextPage()),
        ).then((_) {
          setState(() {
            _isRunning = false;
          });
        });
      }
    } else {
      _timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          setState(() {
            _millisecond += 100;
            if (_millisecond == 1000) {
              _second++;
              _millisecond = 0;
            }
            if (_second == 60) {
              _minute++;
              _second = 0;
            }
            if (_minute == 60) {
              _hour++;
              _minute = 0;
            }
          });
        },
      );
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  // ignore: non_constant_identifier_names
  void ResetTimer() {
    _timer?.cancel();
    setState(() {
      _hour = 0;
      _minute = 0;
      _second = 0;
      _millisecond = 0;
      _isRunning = false;
    });
  }
}
