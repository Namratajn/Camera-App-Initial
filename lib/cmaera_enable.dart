import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart" ;
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:open_file/open_file.dart';

class CameraEnable extends StatefulWidget {
  // const CameraEnable({super.key});

  @override
  State<CameraEnable> createState() => _CameraEnableState();
}

class _CameraEnableState extends State<CameraEnable> {


  File? imageFile ;

  PlatformFile? pickedFile2;
  String _filePath = '';


  XFile? pickedFile ;

  String _imageName = '';

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void _openFileXfile(XFile file) {
    OpenFile.open(file.path);
  }

  void _getFromCamera() async{
    pickedFile= await ImagePicker().pickImage(
        source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    setState(() {
      imageFile = File(pickedFile!.path);
      // Gal.putImage(pickedFile.path);
      _imageName = pickedFile!.name ;
    });

    Gal.putImage(pickedFile!.path);

    // Navigator.pop(context);
  }


  Future pickImageFromDevice() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['png', 'jpeg', 'jpg'],
      type: FileType.custom,
    );
    if (result == null) return;
    setState(() {
      pickedFile2 = result.files.first;
      _filePath = pickedFile2!.path ?? '';
      _imageName = pickedFile2!.name ;
    });
  }


  bool flag = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: (){
                _getFromCamera();
                setState(() {
                  flag = true ;
                });
              },
              child: Text('Click Image'),
            ),

            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                pickImageFromDevice();
                setState(() {
                  flag = false ;
                });
              },
              child: Text('Pick Image'),
            ),

            SizedBox(height: 20,),

            Container(
              height: 150,
                width: 250,
                color: Colors.lightBlueAccent,
                child: Center(child: filePath()),
                // flag == true
                //  ? Text(pickedFile!.name,style: TextStyle(color: Colors.black),)
                //  : Text(pickedFile2!.name,style: TextStyle(color: Colors.black),)
            ),

            Container(
              height: 150,
              width: 250,
              color: Colors.lightBlueAccent,
              child:  Text(
                _imageName == ''
                    ? 'No image Selected'
                    : _imageName,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),

            ),

            SizedBox(height: 20,),
            Container(
              height: 80,
              width: 250,
              color: Colors.lightBlueAccent,
              child: Center(
                  child: fileName()),
              // flag == true
              //  ? Text(pickedFile!.name,style: TextStyle(color: Colors.black),)
              //  : Text(pickedFile2!.name,style: TextStyle(color: Colors.black),)
            ),

            // ElevatedButton(
            //   onPressed: (){
            //     var myFile = File(pickedFile2!.name);
            //     myFile.open();
            //   },
            //   child: Text('View Image'),
            // ),

          ],
        ),
      ),
    );
  }

  Widget fileName(){
    if(flag == true){
      return InkWell(
        onTap: (){
          _openFileXfile(pickedFile!);
        },
        child: Text(
          pickedFile == null
          ? 'no data'
          : pickedFile!.name,style: TextStyle(color: Colors.black),
        ),
      );
    }else{

      return  InkWell(
        onTap: (){
          _openFile(pickedFile2!);
        },
        child: Text(
          pickedFile2 == null
              ? 'no data'
              : pickedFile2!.name,style: TextStyle(color: Colors.black),
        ),
      );
    }
  }


  Widget filePath(){
    if(flag == true){
      return InkWell(
        onTap: (){
          _openFileXfile(pickedFile!);
        },
        child: Text(
          pickedFile == null
              ? 'no data'
          // : pickedFile!.name,style: TextStyle(color: Colors.black),
              : imageFile!.path,style: TextStyle(color: Colors.black),
        ),
      );
    }else{

      return  InkWell(
        onTap: (){
          _openFile(pickedFile2!);
        },
        child: Text(
          pickedFile2 == null
              ? 'no data'
          // : pickedFile2!.name,style: TextStyle(color: Colors.black),
              : _filePath ,style: TextStyle(color: Colors.black),
        ),
      );
    }
  }

}

