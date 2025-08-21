import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:task5/filePages.dart';
import 'package:video_player/video_player.dart';
import 'package:open_file/open_file.dart';


class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final ImagePicker picker = ImagePicker();
  TextEditingController createFolder= TextEditingController();


  List<File> images = [];
  List<File> videos = [];
  List<File> files = [];
  List<String> folders=['Photos','Videos', 'Documents'];
  List<VideoPlayerController> videoControllers = [];

  Future<void> getGallery() async {
    Navigator.pop(context);
    final allFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'mp4', 'mov', 'avi'],
      allowMultiple: true,
    );

    if (allFiles != null && allFiles.files.isNotEmpty) {
      for (var picked in allFiles.files) {
        final file = File(picked.path!);
        final ext = file.path.split('.').last.toLowerCase();

        if (['jpg', 'jpeg', 'png'].contains(ext)) {
          // Crop if single selection
          if (allFiles.files.length == 1) {
            final cropped = await ImageCropper().cropImage(
              maxHeight: 300,
              sourcePath: file.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              uiSettings: [
                AndroidUiSettings(toolbarTitle: 'Crop Image'),
                IOSUiSettings(title: 'Crop Image'),
              ],
            );
            if (cropped != null) {
              setState(() => images.add(File(cropped.path)));
            } else {
              setState(() => images.add(file));
            }
          } else {
            setState(() => images.add(file));
          }
        } else if (['mp4', 'mov', 'avi'].contains(ext)) {
          final controller = VideoPlayerController.file(file);
          await controller.initialize();
          controller.setLooping(true);
          setState(() {
            videos.add(file);
            videoControllers.add(controller);
          });
        } else {
          setState(() => files.add(file));
        }
      }
    }
  }

  Future<void> openCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final croppedImage = await ImageCropper().cropImage(
        maxHeight: 300,
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Crop Image', aspectRatioPresets: [CropAspectRatioPreset.original]),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );
      if (croppedImage != null) {
        setState(() => images.add(File(croppedImage.path)));
      } else {
        setState(() => images.add(File(pickedFile.path)));
      }
    }
  }



  Future<void> pickedFile() async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    if (result != null) {
      for (var picked in result.files) {
        setState(() {
          files.add(File(picked.path!));

        });

      }
    }
  }

  void openUploadFile (String filePath) async{
    await OpenFile.open(filePath);
  }


  Widget buildVideoItem(VideoPlayerController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Positioned(
          child: FloatingActionButton.small(
            backgroundColor: Colors.black54,
            onPressed: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
            child: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Photos'),
                Tab(text: 'Videos'),
                Tab(text: 'Files'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: images.isEmpty
                        ? const Center(child: Text('No image'))
                        : GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      children: images
                          .map(
                            (file) => ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(file, fit: BoxFit.cover),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  // Videos
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: videos.isEmpty
                        ? const Center(child: Text('No video'))
                        : GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return buildVideoItem(videoControllers[index]);
                      },
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(5), child: ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                    return ListTile(leading: Icon(Icons.folder), title: Text('${folders[index]}'), onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Filepages(images,videos, files, folders[index]);
                      },));
                    },);
                  },),)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showOptions,
        child: const Icon(Icons.file_upload_outlined),
      ),
    );
  }

  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            ListTile(title: const Text('Camera'), onTap: openCamera),
            ListTile(title: const Text('Gallery'), onTap: getGallery),
            ListTile(title: const Text('Files'), onTap: pickedFile),
          ],
        ),
      ),
    );
  }
}