import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Differences Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FindDifferencesPage(),
    );
  }
}

class FindDifferencesPage extends StatefulWidget {
  const FindDifferencesPage({super.key});

  // ... 省略不变的代码

  @override
  _FindDifferencesPageState createState() => _FindDifferencesPageState();
}

class _FindDifferencesPageState extends State<FindDifferencesPage> {
  // ... 已有的定义
  GlobalKey leftImageKey = GlobalKey();
  GlobalKey rightImageKey = GlobalKey();

  DifferencesPainter customPainter = DifferencesPainter(differences, shouldRepaintFlag: true);

  void _onTapUp(TapUpDetails details, GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
    bool foundDifference = false;

    setState(() {
      for (var difference in differences) {
        if (difference.area.contains(localPosition)) {
          difference.isFound = true;
          foundDifference = true;
          break;
        }
      }

      if (foundDifference) {
        customPainter = DifferencesPainter(differences, shouldRepaintFlag: true);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the Differences'),
      ),
      body: Column(
        children: [
          const Spacer(flex: 1,),
          Expanded(
            flex: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTapUp: (details) => _onTapUp(details, leftImageKey),
                  child: Stack(
                    children: [
                      Container(
                        key: leftImageKey,
                        width: 400,
                        height: 400,
                        child: Image.asset('assets/images/1.png', fit: BoxFit.cover),
                      ),
                      CustomPaint(
                        painter: customPainter,
                        child: Container(
                          width: 400,
                          height: 400,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTapUp: (details) => _onTapUp(details, rightImageKey),
                  child: Stack(
                    children: [
                      Container(
                        key: rightImageKey,
                        width: 400,
                        height: 400,
                        child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
                      ),
                      CustomPaint(
                        painter: customPainter,
                        child: Container(
                          width: 400,
                          height: 400,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1,),
        ],
      ),
    );
  }
}


class Difference {
  Rect area;
  bool isFound;

  Difference(this.area, {this.isFound = false});
}

List<Difference> differences = [
  Difference(const Rect.fromLTWH(0, 0, 80, 80)),
  Difference(const Rect.fromLTWH(320, 0, 80, 80)),
  // ... 其他差异区域
];

class DifferencesPainter extends CustomPainter {
  final List<Difference> differences;
  final bool shouldRepaintFlag;

  DifferencesPainter(this.differences, {this.shouldRepaintFlag = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var difference in differences) {
      if (difference.isFound) {
        final adjustedRect = Rect.fromLTWH(
          difference.area.left,
          difference.area.top,
          difference.area.width,
          difference.area.height,
        );
        canvas.drawRect(adjustedRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return shouldRepaintFlag;
  }
}


