import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map data = {};
  bool isChanged = false;
  final todoController = TextEditingController();
  final detailsController = TextEditingController();

  bool isAltered() {
    return (data['todo'] != todoController.text || data['details'] != detailsController.text) ? true : false;
  }

  passDataToController(Map data) {
    todoController.text = data['todo'];
    detailsController.text = data['details'];
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context)!.settings.arguments as Map;
      passDataToController(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        var result = isAltered();
        setState(() => isChanged = result);
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.delete)),
              Container(
                child: isChanged
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.check_mark))
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
                            hintText: 'Add details'
                          )
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: const [
                      Icon(CupertinoIcons.calendar),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: 'Add date/time'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              elevation: 20.0,
              shape: const CircularNotchedRectangle(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Mark completed'))
                ],
              )
          )),
    );
  }
}
