import 'package:flutter/material.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/data/task_inherited.dart';
import 'package:sc_ye_gestao_de_saude/pages/pages2/form_screen.dart';
import 'package:sc_ye_gestao_de_saude/pages/register_options.dart';


class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('Tarefas'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8,bottom: 70),
        children: TaskInherited.of(context).taskList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormScreen(taskContext: context,),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
