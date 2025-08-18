import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';

class Filepages extends StatefulWidget {
  List<File> images=[];
  List<File> videos=[];
  List<File> files;
  String? folder;

   Filepages(this.images, this.videos, this.files,  this.folder, {super.key});

  @override
  State<Filepages> createState() => _FilepagesState(this.images, this.videos, this.files, this.folder);
}

class _FilepagesState extends State<Filepages> {

  TextEditingController createFolder= TextEditingController();

  List<String> folders=[];
  List<File> images=[];
  List<File> videos=[];
  List<File> files=[];
  String? folder;

  _FilepagesState(this.images, this.videos, this.files, this.folder);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [IconButton(onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text('New Folder'),
              content: Form(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: createFolder,
                  validator: (value) => (value=='')?'Enter folder name':null,
                  decoration: InputDecoration(
                      hintText: 'Enter folder name',
                      border: OutlineInputBorder()),
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context) , child: Text('Cancel')), OutlinedButton(onPressed: () {
                setState(() {
                  folders.add(createFolder.text);
                  createFolder.clear();
                  Navigator.pop(context);
                });
              }, child: Text('Create'))],
            );
          },);
        }, icon: Icon(Icons.menu))],
        title: const Text(
          'File Uploads',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
        ),
      ),
      body: Column(
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(

                style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
                  children: [TextSpan(text: 'File Uploads'), TextSpan(text: '>'), TextSpan(text: '${folder}'),  ])),
        ),
          Expanded(child: ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
            return ListTile(leading: Icon(Icons.file_copy),);
          },))
        ],
      ),
    );
  }
}
