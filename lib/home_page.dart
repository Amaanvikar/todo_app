import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  final ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  final _controller = TextEditingController();

  // List toDoList = [
  //   ["Make Tutorial", false],
  //   ["Do Exercise", false],
  // ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('To Do'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewTask(context);
        },
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDolist(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },

        // children: [
        //   ToDolist(
        //     taskName: "Make Tutorial",
        //     taskCompleted: true,
        //     onChanged: (p0) {},
        //   ),
        //   ToDolist(
        //     taskName: "DO Exercise",
        //     taskCompleted: false,
        //     onChanged: (p0) {},
        //   ),
        // ],
      ),
    );
  }
}
