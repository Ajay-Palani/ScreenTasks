import 'package:flutter/material.dart';
import 'package:task4/DetailsList.dart';

class Createlist extends StatefulWidget {
  const Createlist({super.key});

  @override
  State<Createlist> createState() => _CreatelistState();
}

class _CreatelistState extends State<Createlist> {
  List<TextEditingController> nameController = [];
  final formkey = GlobalKey<FormState>();

  add() {
    setState(() {
      nameController.add(TextEditingController());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    add();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Form(
        key: formkey,
        child: SizedBox(
          width: width * 1,
          height: height * 1,
          child: Column(
            children: [
              SizedBox(
                width: width * 1,
                height: height * 0.8,
                child: ListView.builder(
                  itemCount: nameController.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.80,
                            child: TextFormField(
                              controller: nameController[index],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return 'Please enter details';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          Visibility(
                            visible: (index == nameController.length - 1)
                                ? true
                                : false,
                            child: Expanded(
                              child: IconButton(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    return add();
                                  }
                                },
                                icon: Icon(Icons.add_circle_outline_outlined),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Visibility(
                              visible: (nameController.length > 1
                                  ? true
                                  : false),

                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    nameController.removeAt(index);
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline_outlined,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              FloatingActionButton(
                onPressed: () {
                  print('Button');
                  if (formkey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailslist(nameController),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
