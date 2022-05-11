import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final VoidCallback onRefresh;
  const Input({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isTextFieldVisible = false;
  final _formKey = GlobalKey<FormState>();
  String task = '';
  String details = '';

  // Future saveTodo() async {
  //   final result = await Services.postTodo(task, details);
  //   if (!result['success']) {
  //     Fluttertoast.showToast(msg: result['message']);
  //   } else {
  //     Fluttertoast.showToast(msg: result['message']);
  //     widget.onRefresh;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 10.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              TextField(
                onChanged: (value) => setState(() => task = value),
                autofocus: true,
                decoration:
                    const InputDecoration.collapsed(hintText: 'New task'),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                child: isTextFieldVisible
                    ? TextField(
                        onChanged: (value) => setState(() => details = value),
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
                        setState(() {
                          isTextFieldVisible = !isTextFieldVisible;
                        });
                      },
                      icon: const Icon(Icons.menu_open)),
                  const Spacer(),
                  TextButton(
                      onPressed: task.isEmpty ? null : () => widget.onRefresh,
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: task.isEmpty
                                ? Colors.grey[400]
                                : Colors.grey[800]),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
