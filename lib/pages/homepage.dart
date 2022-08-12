import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imageupload/providers/login_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: context.watch<LoginProvider>().isUploading,
      progressIndicator: Material(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(30),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 10,
                ),
                Text(context.watch<LoginProvider>().message)
              ]),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18, 18, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName!,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<LoginProvider>().signOut(context);
                        },
                        icon: const Icon(
                          Icons.power_settings_new_sharp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
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
                        context
                            .read<LoginProvider>()
                            .gotoDisplayImages(context);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(10),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Pick Images',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                          onPressed: () {
                            context.read<LoginProvider>().pickImage();
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(10),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                          onPressed: () {
                            context.read<LoginProvider>().uploadImages(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (context.watch<LoginProvider>().imageData.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Click Pick Images button to select images',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  if (context.watch<LoginProvider>().images != null)
                    Expanded(
                      child: ListView.separated(
                          itemCount:
                              context.watch<LoginProvider>().imageData.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 15,
                              ),
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue.withOpacity(0.2)),
                                    child: TextField(
                                      controller: context
                                          .watch<LoginProvider>()
                                          .imageData[index]
                                          .titleController,
                                      decoration: const InputDecoration(
                                          label: Text("Image Title"),
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          fillColor: Colors.blue),
                                    ),
                                  ),
                                  Image.file(
                                    File(context
                                        .watch<LoginProvider>()
                                        .imageData[index]
                                        .imageFile!
                                        .path),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
