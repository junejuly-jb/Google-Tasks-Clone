import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:rest_auth_login/shared/input.dart';
import '../models/todo.dart';
import '../services/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Todo>> futureTodo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          return const Input();
        });
  }

  @override
  Widget build(BuildContext context) {
    void doNothing(BuildContext context) {}

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
                IconButton(onPressed: openDrawer, icon: const Icon(Icons.menu)),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
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
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              futureTodo = Services.getTodos();
            });
          },
          child: Column(
            children: [
              FutureBuilder<List<Todo>>(
                future: futureTodo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 0.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Todo todo = snapshot.data![index];
                            return Slidable(
                                key: const ValueKey(0),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: doNothing,
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: doNothing,
                                      backgroundColor: const Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.share,
                                      label: 'Share',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: IconButton(
                                    icon: todo.flag
                                        ? const Icon(Icons.task_alt_outlined)
                                        : const Icon(Icons.circle_outlined),
                                    onPressed: () {},
                                  ),
                                  title: Text(todo.todo),
                                  subtitle: todo.details.isEmpty
                                      ? null
                                      : Text(todo.details),
                                ));
                            // return ListTile(
                            //   title: Text(todo.todo),
                            // );
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
