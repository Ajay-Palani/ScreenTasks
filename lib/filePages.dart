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
            itemCount:(folder=='Photos')? images.length:(folder=='Videos')?videos.length:(folder=='Documents')?files.length:null,
            itemBuilder: (context, index) {
              if(folder=='Photos'){
                return ListTile(leading: Icon(Icons.image),title: Text(images[index].path.split('/').last),);

              }
              else if(folder=='Videos'){
                return ListTile(leading: Icon(Icons.video_camera_back),title: Text(videos[index].path.split('/').last),);
              }
              else if(folder=='Documents'){
                return ListTile(leading: Icon(Icons.file_copy),title: Text(files[index].path.split('/').last),);
              }
              },))
        ],
      ),
    );
  }
}
