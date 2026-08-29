import 'package:flutter/material.dart';

void main() {
  runApp(const AricilikWorkflowApp());
}

class AricilikWorkflowApp extends StatelessWidget {
  const AricilikWorkflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arıcılık Workflow',
      theme: ThemeData.dark(),
      home: const WorkflowScreen(),
    );
  }
}

class WorkflowScreen extends StatefulWidget {
  const WorkflowScreen({super.key});

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

class _WorkflowScreenState extends State<WorkflowScreen> {
  final Map<String, Offset> positions = {
    'İKLİM': const Offset(70, 100),
    'FLORA': const Offset(40, 330),
    'KOLONİ': const Offset(310, 280),
    'KOVAN': const Offset(310, 500),
    'ÜRETİM': const Offset(590, 280),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐝 Arıcılık Workflow v0.1'),
        backgroundColor: const Color(0xFF202124),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 2.5,
        boundaryMargin: const EdgeInsets.all(600),
        constrained: false,
        child: SizedBox(
          width: 1000,
          height: 1000,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ConnectionPainter(positions),
                ),
              ),

              buildNode('İKLİM', '🌦️', 'Nisan • 22 °C'),
              buildNode('FLORA', '🌼', 'Nektar: Orta'),
              buildNode('KOLONİ', '🐝', '18.000 işçi arı'),
              buildNode('KOVAN', '🏠', '10 çerçeve'),
              buildNode('ÜRETİM', '🍯', 'Bal: 4.2 kg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNode(String name, String icon, String info) {
    final position = positions[name]!;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            positions[name] = positions[name]! + details.delta;
          });
        },
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF303238),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF666A73),
              width: 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: const BoxDecoration(
                  color: Color(0xFF454850),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 21),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        info,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final Map<String, Offset> positions;

  ConnectionPainter(this.positions);

  void connect(Canvas canvas, String from, String to) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final start = positions[from]! + const Offset(180, 55);
    final end = positions[to]! + const Offset(0, 55);

    final path = Path();
    path.moveTo(start.dx, start.dy);

    final middle = (start.dx + end.dx) / 2;

    path.cubicTo(
      middle,
      start.dy,
      middle,
      end.dy,
      end.dx,
      end.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    connect(canvas, 'İKLİM', 'KOLONİ');
    connect(canvas, 'FLORA', 'KOLONİ');
    connect(canvas, 'KOLONİ', 'ÜRETİM');
    connect(canvas, 'KOVAN', 'KOLONİ');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
