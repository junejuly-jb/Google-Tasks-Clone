import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_auth_login/services/services.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map data = {};
  String? id;
  bool flag = false;
  bool isValuesChanged = false;
  String text = '';
  bool isChanged = false;
  bool isLoading = false;
  final todoController = TextEditingController();
  final detailsController = TextEditingController();

  bool isAltered() {
    return (data['todo'] != todoController.text || data['details'] != detailsController.text) ? true : false;
  }

  passDataToController(Map data) {
    todoController.text = data['todo'];
    detailsController.text = data['details'];
    setState(() {
      id = data['id'];
      flag = data['flag'];
      text = data['flag'] ? 'Mark as incomplete' : 'Mark as complete';
    });

  }

  showDeleteDialog(){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text('Delete?'),
          content: const Text('Do you want to delete this todo?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),child: const Text('Cancel')),
            // TextButton(onPressed: deleteTodo, child: const Text('Delete')),
            isLoading ? 
            TextButton.icon(
              onPressed: (){}, 
              icon: Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 3,
                ),
              ), 
              label: const Text('Delete', style: TextStyle(color: Colors.grey),)
            ) : 
            TextButton(
              child: const Text('Delete'),
              onPressed: deleteTodo,
            )
          ],
      )
    );
  }

  Future deleteTodo() async {
    setState(() => isLoading = true);
    final result = await Services.deleteTodo(data['id']);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: result['message']);
    if(result['status'] == 200){
      setState(() => isValuesChanged = true);
      Navigator.pop(context, isValuesChanged);
    }
  }

  Future toggleTodo(String? id, bool pflag) async{
    final result = await Services.todoToggler(id, pflag);
    Fluttertoast.showToast(msg: result['message']);
    if(result['status'] == 200){
      print('200');
      setState((){
        isValuesChanged = true;
        flag = !flag;
        text = flag ? 'Mark as incomplete' : 'Mark as complete';
      });
    }
  }

  void listener(){
    dynamic result = isAltered();
    setState(() => isChanged = result);
  } 

  Future updateTodo() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await Services.updateTodo(id, todoController.text, detailsController.text);
    Fluttertoast.showToast(msg: result['message']);
    if(result['status'] == 500){
      todoController.text = data['todo'];
      detailsController.text = data['details'];
    }
    else{
      setState((){
        isChanged = false;
        isValuesChanged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context)!.settings.arguments as Map;
      todoController.addListener(listener);
      detailsController.addListener(listener);
      passDataToController(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, isValuesChanged);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: showDeleteDialog,
                  icon: const Icon(CupertinoIcons.delete)),
              Container(
                child: isChanged
                    ? IconButton(
                        onPressed: updateTodo,
                        icon: const Icon(CupertinoIcons.checkmark_alt))
                    : null,
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      controller: todoController,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Add details')),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.text_alignleft),
                      const SizedBox(width: 20.0),
                      Expanded(
                          child: TextFormField(
                              controller: detailsController,
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'Add details')))
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
                elevation: 10.0,
                shape: const CircularNotchedRectangle(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: TextButton(onPressed: () {
                        toggleTodo(id, flag);
                      }, child: Text(text)),
                    )
                  ],
                )
            )
        ),
      ),
    );
  }
}
