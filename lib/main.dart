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

enum NodeCategory {
  feeding,
  health,
  hivePhysical,
  colony,
  environment,
  production,
}

class WorkflowNode {
  WorkflowNode({
    required this.id,
    required this.title,
    required this.icon,
    required this.info,
    required this.category,
    required this.position,
  });

  final String id;
  final String title;
  final String icon;
  final String info;
  final NodeCategory category;
  Offset position;
}

class WorkflowConnection {
  WorkflowConnection({
    required this.id,
    required this.fromNodeId,
    required this.toNodeId,
  });

  final String id;
  final String fromNodeId;
  final String toNodeId;
}

class WorkflowScreen extends StatefulWidget {
  const WorkflowScreen({super.key});

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

class _WorkflowScreenState extends State<WorkflowScreen> {
  final TransformationController transformationController =
      TransformationController();

  static const double nodeWidth = 190;
  static const double nodeHeight = 105;

  late final List<WorkflowNode> nodes;

  final List<WorkflowConnection> connections = [];

  String? draggingFromNodeId;
  Offset? draggingConnectionEnd;

  @override
  void initState() {
    super.initState();

    nodes = [
      WorkflowNode(
        id: 'iklim',
        title: 'İKLİM',
        icon: '🌦️',
        info: 'Nisan • 22 °C',
        category: NodeCategory.environment,
        position: const Offset(80, 80),
      ),
      WorkflowNode(
        id: 'flora',
        title: 'FLORA',
        icon: '🌼',
        info: 'Nektar: Orta',
        category: NodeCategory.environment,
        position: const Offset(70, 300),
      ),
      WorkflowNode(
        id: 'koloni',
        title: 'KOLONİ',
        icon: '🐝',
        info: '18.000 işçi arı',
        category: NodeCategory.colony,
        position: const Offset(360, 250),
      ),
      WorkflowNode(
        id: 'kovan',
        title: 'KOVAN İŞLEMİ',
        icon: '🏠',
        info: 'Çıta • Kat • Bölme',
        category: NodeCategory.hivePhysical,
        position: const Offset(350, 500),
      ),
      WorkflowNode(
        id: 'uretim',
        title: 'ÜRETİM',
        icon: '🍯',
        info: 'Bal: 4.2 kg',
        category: NodeCategory.production,
        position: const Offset(660, 250),
      ),
      WorkflowNode(
        id: 'besleme',
        title: 'BESLEME',
        icon: '🥣',
        info: 'Şurup • Kek',
        category: NodeCategory.feeding,
        position: const Offset(650, 500),
      ),
      WorkflowNode(
        id: 'saglik',
        title: 'SAĞLIK',
        icon: '🩺',
        info: 'Varroa • Hastalık',
        category: NodeCategory.health,
        position: const Offset(650, 720),
      ),
    ];

    connections.addAll([
      WorkflowConnection(
        id: 'c1',
        fromNodeId: 'iklim',
        toNodeId: 'koloni',
      ),
      WorkflowConnection(
        id: 'c2',
        fromNodeId: 'flora',
        toNodeId: 'koloni',
      ),
      WorkflowConnection(
        id: 'c3',
        fromNodeId: 'koloni',
        toNodeId: 'uretim',
      ),
      WorkflowConnection(
        id: 'c4',
        fromNodeId: 'kovan',
        toNodeId: 'koloni',
      ),
    ]);
  }

  WorkflowNode nodeById(String id) {
    return nodes.firstWhere((node) => node.id == id);
  }

  Color categoryColor(NodeCategory category) {
    switch (category) {
      case NodeCategory.feeding:
        return const Color(0xFFB79A7C);
      case NodeCategory.health:
        return const Color(0xFF70C8C4);
      case NodeCategory.hivePhysical:
        return const Color(0xFFD5BF73);
      case NodeCategory.colony:
        return const Color(0xFFB09ACF);
      case NodeCategory.environment:
        return const Color(0xFF91C997);
      case NodeCategory.production:
        return const Color(0xFFE1A76F);
    }
  }

  Offset outputPoint(WorkflowNode node) {
    return node.position + const Offset(nodeWidth, nodeHeight / 2);
  }

  Offset inputPoint(WorkflowNode node) {
    return node.position + const Offset(0, nodeHeight / 2);
  }

  Offset globalToCanvas(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);

    final Matrix4 inverse =
        Matrix4.inverted(transformationController.value);

    return MatrixUtils.transformPoint(
      inverse,
      localPosition,
    );
  }

  WorkflowNode? findInputNodeNear(Offset position) {
    const double radius = 38;

    for (final node in nodes) {
      if ((inputPoint(node) - position).distance <= radius) {
        return node;
      }
    }

    return null;
  }

  void createConnection(String fromId, String toId) {
    if (fromId == toId) return;

    final bool exists = connections.any(
      (connection) =>
          connection.fromNodeId == fromId &&
          connection.toNodeId == toId,
    );

    if (exists) return;

    setState(() {
      connections.add(
        WorkflowConnection(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          fromNodeId: fromId,
          toNodeId: toId,
        ),
      );
    });
  }

  void deleteConnection(String id) {
    setState(() {
      connections.removeWhere(
        (connection) => connection.id == id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bağlantı kaldırıldı'),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        title: const Text('🐝 Arıcılık Workflow v0.2'),
      ),
      body: InteractiveViewer(
        transformationController: transformationController,
        minScale: 0.4,
        maxScale: 3.0,
        boundaryMargin: const EdgeInsets.all(1000),
        constrained: false,
        panEnabled: draggingFromNodeId == null,
        scaleEnabled: draggingFromNodeId == null,
        child: SizedBox(
          width: 1500,
          height: 1300,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: ConnectionPainter(
                    nodes: nodes,
                    connections: connections,
                    draggingFromNodeId: draggingFromNodeId,
                    draggingConnectionEnd: draggingConnectionEnd,
                  ),
                ),
              ),
              ...connections.map((connection) {
                return ConnectionTouchArea(
                  from: outputPoint(
                    nodeById(connection.fromNodeId),
                  ),
                  to: inputPoint(
                    nodeById(connection.toNodeId),
                  ),
                  onDoubleTap: () {
                    deleteConnection(connection.id);
                  },
                );
              }),
              ...nodes.map(buildNode),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNode(WorkflowNode node) {
    final Color baseColor = categoryColor(node.category);

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (draggingFromNodeId != null) return;

          setState(() {
            node.position += details.delta;
          });
        },
        child: SizedBox(
          width: nodeWidth,
          height: nodeHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: baseColor.withOpacity(0.30),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: baseColor,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 43,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.55),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            node.icon,
                            style: const TextStyle(fontSize: 21),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              node.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            node.info,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -11,
                top: nodeHeight / 2 - 10,
                child: socket(
                  const Color(0xFF8FD3FF),
                ),
              ),
              Positioned(
                right: -16,
                top: nodeHeight / 2 - 16,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) {
                    setState(() {
                      draggingFromNodeId = node.id;
                      draggingConnectionEnd = outputPoint(node);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      draggingConnectionEnd =
                          globalToCanvas(details.globalPosition);
                    });
                  },
                  onPanEnd: (_) {
                    final String? fromId = draggingFromNodeId;
                    final Offset? end = draggingConnectionEnd;

                    if (fromId != null && end != null) {
                      final WorkflowNode? target =
                          findInputNodeNear(end);

                      if (target != null) {
                        createConnection(
                          fromId,
                          target.id,
                        );
                      }
                    }

                    setState(() {
                      draggingFromNodeId = null;
                      draggingConnectionEnd = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: socket(
                      const Color(0xFFFFC46B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socket(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  ConnectionPainter({
    required this.nodes,
    required this.connections,
    required this.draggingFromNodeId,
    required this.draggingConnectionEnd,
  });

  final List<WorkflowNode> nodes;
  final List<WorkflowConnection> connections;
  final String? draggingFromNodeId;
  final Offset? draggingConnectionEnd;

  static const double nodeWidth = 190;
  static const double nodeHeight = 105;

  WorkflowNode nodeById(String id) {
    return nodes.firstWhere(
      (node) => node.id == id,
    );
  }

  Offset outputPoint(WorkflowNode node) {
    return node.position +
        const Offset(nodeWidth, nodeHeight / 2);
  }

  Offset inputPoint(WorkflowNode node) {
    return node.position +
        const Offset(0, nodeHeight / 2);
  }

  Path cablePath(Offset start, Offset end) {
    final Path path = Path();

    path.moveTo(start.dx, start.dy);

    final double distance =
        (end.dx - start.dx).abs();

    final double control =
        distance.clamp(80.0, 240.0).toDouble();

    path.cubicTo(
      start.dx + control,
      start.dy,
      end.dx - control,
      end.dy,
      end.dx,
      end.dy,
    );

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint cablePaint = Paint()
      ..color = const Color(0xFFFFB85C)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final connection in connections) {
      final WorkflowNode from =
          nodeById(connection.fromNodeId);

      final WorkflowNode to =
          nodeById(connection.toNodeId);

      canvas.drawPath(
        cablePath(
          outputPoint(from),
          inputPoint(to),
        ),
        cablePaint,
      );
    }

    if (draggingFromNodeId != null &&
        draggingConnectionEnd != null) {
      final WorkflowNode from =
          nodeById(draggingFromNodeId!);

      final Paint temporaryPaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(
        cablePath(
          outputPoint(from),
          draggingConnectionEnd!,
        ),
        temporaryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant ConnectionPainter oldDelegate,
  ) {
    return true;
  }
}

class ConnectionTouchArea extends StatelessWidget {
  const ConnectionTouchArea({
    super.key,
    required this.from,
    required this.to,
    required this.onDoubleTap,
  });

  final Offset from;
  final Offset to;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final double left =
        (from.dx < to.dx ? from.dx : to.dx) - 25;

    final double top =
        (from.dy < to.dy ? from.dy : to.dy) - 25;

    final double width =
        ((from.dx - to.dx).abs() + 50)
            .clamp(50.0, double.infinity)
            .toDouble();

    final double height =
        ((from.dy - to.dy).abs() + 50)
            .clamp(50.0, double.infinity)
            .toDouble();

    final Offset localStart =
        from - Offset(left, top);

    final Offset localEnd =
        to - Offset(left, top);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: CustomPaint(
          painter: CableTouchPainter(
            start: localStart,
            end: localEnd,
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class CableTouchPainter extends CustomPainter {
  CableTouchPainter({
    required this.start,
    required this.end,
  });

  final Offset start;
  final Offset end;

  Path getPath() {
    final double distance =
        (end.dx - start.dx).abs();

    final double control =
        distance.clamp(80.0, 240.0).toDouble();

    return Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + control,
        start.dy,
        end.dx - control,
        end.dy,
        end.dx,
        end.dy,
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Görünmez dokunma alanı.
  }

  @override
  bool hitTest(Offset position) {
    final Path path = getPath();

    for (final metric in path.computeMetrics()) {
      const double step = 6;
      double distance = 0;

      while (distance <= metric.length) {
        final Tangent? tangent =
            metric.getTangentForOffset(distance);

        if (tangent != null &&
            (tangent.position - position).distance < 20) {
          return true;
        }

        distance += step;
      }
    }

    return false;
  }

  @override
  bool shouldRepaint(
    covariant CableTouchPainter oldDelegate,
  ) {
    return true;
  }
}
