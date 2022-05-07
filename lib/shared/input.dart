import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isTextFieldVisible = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 10.0),
        child: Wrap(
          children: [
            const TextField(
              autofocus: true,
              decoration: InputDecoration.collapsed(hintText: 'New task'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: isTextFieldVisible ? const TextField(
                decoration: InputDecoration.collapsed(hintText: 'Add details')
              ) : null,
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
                  icon: const Icon(Icons.menu_open)
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.grey[800]),
                  ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
