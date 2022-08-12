import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageupload/main.dart';
import 'package:imageupload/model/imageModel.dart';
import 'package:imageupload/model/uploadedModel.dart';
import 'package:imageupload/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imageupload/pages/uploadedImage.dart';

class LoginProvider with ChangeNotifier {
//The above method get's data from user device and then send the data to
//the Google server for authentiacation.  If the authentication is verified then,
//it returns token and user ID from the Google server.
// At last we send the data to the Firebase server for login.

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign out
  signOut(context) async {
    imageData.clear();
    if (images != null) {
      images!.clear();
    }
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut().then((value) {
      Fluttertoast.showToast(msg: "Logout Successful");
    });
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? images;
  List<ImageModel> imageData = [];

  pickImage() async {
    images = await _picker.pickMultiImage(imageQuality: 30);
    if (images != null) {
      for (var img in images!) {
        imageData.add(ImageModel(imageFile: img));
      }
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "User cancelled");
    }
  }

  bool isUploading = false;
  String message = "Loading";
  FirebaseStorage storage = FirebaseStorage.instance;
  // List<UploadedModel> urls = [];

  uploadImages(context) async {
    if (images == null) {
      return Fluttertoast.showToast(msg: "Please select Images");
    } else {
      for (var img in imageData) {
        if (img.titleController!.text.trim() == "") {
          Fluttertoast.showToast(msg: "Please enter Image title");
          return;
        }
      }
      isUploading = true;
      message = "Images uploading in progress...";
      notifyListeners();
      //urls = [];
      for (var imageFile in imageData) {
        try {
          // Uploading the selected image with some custom meta data
          var result = storage
              .ref(
                  "${FirebaseAuth.instance.currentUser!.uid}/${imageFile.imageFile!.path.split("/").last}")
              .putFile(
                  File(imageFile.imageFile!.path),
                  SettableMetadata(customMetadata: {
                    'uploaded_by': '',
                    'description': imageFile.titleController!.text.trim(),
                  }));
          await result.whenComplete(() => null);
          notifyListeners();
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      }
      imageData.clear();
      images!.clear();
      Fluttertoast.showToast(msg: "image uploaded");
      isUploading = false;
      notifyListeners();
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (thisContext) {
            return StatefulBuilder(builder: (thisContext, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                    "Thank you ${FirebaseAuth.instance.currentUser!.displayName!},\nyour Images Uploaded Successfully"),
                content: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 65,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(10),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'View Uploaded Images',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        gotoDisplayImages(context);
                      },
                    ),
                  ),
                ],
              );
            });
          });
    }
  }

  goBack(context) {
    Navigator.pop(context);
  }

  logout(context) async {
    imageData.clear();
    if (images != null) {
      images!.clear();
    }
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut().then((value) {
      Fluttertoast.showToast(msg: "Logout Successful");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    });
  }

  List<UploadedModel> uploadedFiles = [];

  loadImagesFirebase() async {
    uploadedFiles = [];
    isUploading = true;
    message = "Loading Images from Firebase...";
    notifyListeners();
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid);
    ListResult result = await storageRef.listAll();

    for (var element in result.items) {
      FullMetadata metaData = await element.getMetadata();
      String downloadUrl = await element.getDownloadURL();
      uploadedFiles.add(UploadedModel(
          title: metaData.customMetadata!['description'] ?? "",
          url: downloadUrl));
    }
    isUploading = false;
    notifyListeners();
  }

  gotoDisplayImages(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DisplayImages()));
  }
}
