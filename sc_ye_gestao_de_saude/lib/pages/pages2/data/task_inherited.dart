import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/task.dart';

class TaskInherited extends InheritedWidget {
  TaskInherited({
    super.key,
    required super.child,
  });

  final List<Task> taskList = [
     Task('Flutter', 'assets/images/flutter.png', 3),
     Task('Figma', 'assets/images/figma.webp', 2),
     Task('Estrutra de dados',
        'assets/images/81aYcGlPpSL._AC_UF1000,1000_QL80_.jpg', 5),
     Task('Calculo', 'assets/images/calculo.jpeg', 4),
     Task('Fisica', 'assets/images/fisica.webp', 3),
     Task('Paradigmas',
        'assets/images/paradigma-de-programacao-orientada-a-objeto.jpg', 3),
     Task('Desenvolvimento Agil', 'assets/images/agil.jpg', 2),
  ];

  void newTask(String name, String photo, int difficulty) {
    taskList.add(Task(name, photo, difficulty));
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result =
        context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList.length != taskList.length;
  }
}
