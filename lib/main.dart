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
