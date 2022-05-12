import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/todo.dart';
import '../services/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Todo>> futureTodo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureTodo = Services.getTodos();
  }

  openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void showSettingsPanel() {
    _scaffoldKey.currentState!.openEndDrawer();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          bool isTextFieldVisible = false;
          String task = '';
          String details = '';
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 10.0),
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    children: [
                      TextField(
                        onChanged: (value) => mystate(() => task = value),
                        autofocus: true,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'New task'),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: isTextFieldVisible
                            ? TextField(
                                onChanged: (value) {
                                  mystate(() => details = value);
                                },
                                decoration: const InputDecoration.collapsed(
                                    hintText: 'Add details'))
                            : null,
                      ),
                      Row(
                        children: [
                          IconButton(
                              color: Colors.blue,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                mystate(() {
                                  isTextFieldVisible = !isTextFieldVisible;
                                });
                              },
                              icon: const Icon(Icons.menu_open)),
                          const Spacer(),
                          TextButton(
                              onPressed: task.isEmpty
                                  ? null
                                  : () async {
                                      final result = await Services.postTodo(
                                          task, details);
                                      if (!result['success']) {
                                        Fluttertoast.showToast(
                                            msg: result['message']);
                                      } else {
                                        await refresh();
                                        Fluttertoast.showToast(
                                            msg: result['message']);
                                        Navigator.pop(context);
                                      }
                                    },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: task.isEmpty
                                        ? Colors.grey[400]
                                        : Colors.grey[850]),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  refresh() {
    setState(() {
      futureTodo = Services.getTodos();
    });
  }

  buttonPress(String id, bool flag) async {
    final result = await Services.todoToggler(id, flag);
    if (result['status'] == 200) {
      Fluttertoast.showToast(msg: result['message']);
      refresh();
    }
    else{
      Fluttertoast.showToast(msg: result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: showSettingsPanel,
        ),
        bottomNavigationBar: BottomAppBar(
            elevation: 20.0,
            shape: const CircularNotchedRectangle(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: IconButton(onPressed: openDrawer, icon: const Icon(Icons.menu)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                )
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () async {
                    await SessionManager().destroy();
                    Navigator.popAndPushNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Tasks'),
          elevation: 0,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            refresh();
          },
          child: Column(
            children: [
              FutureBuilder<List<Todo>>(
                future: futureTodo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Todo todo = snapshot.data![index];
                            return ListTile(
                              onTap: () async {
                                var result = await Navigator.pushNamed(context, '/details', arguments: {
                                  "id": todo.id,
                                  "todo": todo.todo,
                                  "details": todo.details,
                                  "flag": todo.flag
                                });
                                print(result.runtimeType);
                                if(result != null){
                                  // Fluttertoast.showToast(msg: result.message);
                                  refresh();
                                }
                              },
                              leading: IconButton(
                                icon: todo.flag
                                    ? const Icon(Icons.task_alt_outlined)
                                    : const Icon(Icons.circle_outlined),
                                onPressed: (){
                                  // todo[index].todo = 'Hello World';
                                  buttonPress(todo.id, todo.flag);
                                },
                              ),
                              title: Text(
                                todo.todo,
                                style: TextStyle(
                                  decoration: todo.flag ? TextDecoration.lineThrough : null
                                ),
                              ),
                              subtitle: todo.details.isEmpty
                                  ? null
                                  : Text(
                                      todo.details,
                                      style: TextStyle(
                                        decoration: todo.flag? TextDecoration.lineThrough : null
                                      ),
                                    ),
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
