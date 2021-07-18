import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';

// This is the home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This creates an instance of the Google ML Vision Text Recognizer
  final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
  // This creates an instance of the FlutterTTS library to help us use the text to speech API
  final FlutterTts flutterTts = FlutterTts();
  // This creates an instance of the Image Picker library. This library helps us to choose an image from gallery or take a new picture with the camera.
  final imagePicker = ImagePicker();
  // Variable declarations
  PickedFile? pickedImage;
  File? imageFile;


  // This builds the interface of the Home Screen
  @override
  Widget build(BuildContext context) {

    // Sets speech rate
    double speechRate = 0.5;
    // Sets speech volume
    double speechVolume = 1;
    // Sets speech pitch
    double speechPitch = 1;


    return Scaffold(
      // This shows the blue App Bar with Audify text
      appBar: AppBar(
        title: Text('Audify'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.app_settings_alt_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Settings'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('Speech Rate'),
                                Slider(
                                    value: speechRate,
                                    min: 0,
                                    max: 1,
                                    divisions: 10,
                                    label: speechRate.toStringAsFixed(1),
                                    onChanged: (value) {
                                      setState(() {
                                        speechRate = value;
                                      });
                                    }),
                                Text('Speech Volume'),
                                Slider(
                                    value: speechVolume,
                                    min: 0,
                                    max: 1,
                                    divisions: 10,
                                    label: speechVolume.toStringAsFixed(1),
                                    onChanged: (value) {
                                      setState(() {
                                        speechVolume = value;
                                      });
                                    }),
                                Text('Speech Pitch'),
                                Slider(
                                    value: speechPitch,
                                    min: 0,
                                    max: 1,
                                    divisions: 10,
                                    label: speechPitch.toStringAsFixed(1),
                                    onChanged: (value) {
                                      setState(() {
                                        speechPitch = value;
                                      });
                                    })
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Done'),
                            )
                          ],
                        );
                    });
                  });
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //This container shows an icon of a photo when an image is not selected and an actual photo when an image is selected
              Container(
                child: imageFile == null
                    ? Icon(Icons.photo)
                    : Image.file(imageFile!, height: 301),
              ),
              // This button lets you pick an image from the gallery
              TextButton(
                child: Text('Pick image'),
                onPressed: () {
                  setState(() {
                    pickImage(ImageSource.gallery);
                  });
                },
              ),
              // This button lets you take a picture
              TextButton(
                child: Text('Take a picture'),
                onPressed: () {
                  setState(() {
                    pickImage(ImageSource.camera);
                  });
                },
              ),
              // This button makes the text to speech engine read the text found on the image
              TextButton(
                child: Text('Start reading'),
                onPressed: () async {
                  // The code in this block extracts the text from the selected image and reads it
                  GoogleVisionImage visionImage =
                      GoogleVisionImage.fromFile(imageFile!);
                  VisionText visionText =
                      await textRecognizer.processImage(visionImage);
                  speak(text: visionText.text!, volume: speechVolume, pitch: speechPitch, rate: speechRate);
                },
              ),
              // This button makes the text to speech engine stops reading
              TextButton(
                child: Text('Stop reading'),
                onPressed: () {
                  flutterTts.stop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This function handles picking an image or taking a picture and cropping it
  void pickImage(ImageSource source) async {
    pickedImage = await imagePicker.getImage(source: source);
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage!.path,
        androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.blue,
            statusBarColor: Colors.blue,
            activeControlsWidgetColor: Colors.blue,
            backgroundColor: Colors.white,
            hideBottomControls: true));
    setState(() {
      // imageFile = File(pickedImage!.path);
      imageFile = File(croppedFile!.path);
    });
  }

  // This function handles the voice, speed and speaking of the text to speech engine
  Future speak({required String text, required double rate, required double pitch, required double volume}) async {
    await flutterTts.setVoice({"name": "en-gb-x-gba-local", "locale": "en-GB"});
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.speak(text);
  }
}
