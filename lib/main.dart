import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

import 'cmaera_enable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  CameraEnable()
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  List<CameraDescription> cameras = [];
  CameraController? cameraController ;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(cameraController == null || cameraController?.value.isInitialized == false){
      return ;
    }
    if(state == AppLifecycleState.inactive){
      cameraController?.dispose();
    }else if (state == AppLifecycleState.resumed){
      _setUpCameraController();
    }
  }
  @override
  void initState() {
    super.initState();
    _setUpCameraController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _buildUI(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildUI(){
    if(cameraController == null || cameraController?.value.isInitialized == false){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return SafeArea(child: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height *0.30 ,
            width: MediaQuery.sizeOf(context).width * 0.80,
              child: CameraPreview(
                cameraController!,)
          ),

          IconButton(
              onPressed: () async{
                XFile picture = await cameraController!.takePicture();
                Gal.putImage(picture.path);
          },
            iconSize : 100,
            icon: Icon(Icons.camera,color: Colors.pink,))
        ],
      ),
    ),
    );
    
  }

  Future<void> _setUpCameraController() async{
    List<CameraDescription> _cameras = await availableCameras();
    if(_cameras.isNotEmpty){
      setState(() {
        cameras=_cameras;
        cameraController = CameraController(_cameras.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        if(!mounted){
          return ;
        }
        setState(() {

        });
      }).catchError((Object e){
        print(e);
      });

    }
  }
}
