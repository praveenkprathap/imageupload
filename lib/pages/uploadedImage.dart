import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imageupload/model/uploadedModel.dart';
import 'package:imageupload/providers/login_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class DisplayImages extends StatefulWidget {
  //late List<UploadedModel> images;
  DisplayImages({Key? key}) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<LoginProvider>().loadImagesFirebase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: context.watch<LoginProvider>().isUploading,
        progressIndicator: Material(
          color: Colors.transparent,
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
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        context.read<LoginProvider>().goBack(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${FirebaseAuth.instance.currentUser!.displayName!}",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Text(
                        context.read<LoginProvider>().uploadedFiles.isEmpty
                            ? "There is no Image to display"
                            : "Images you Uploaded are Shown below",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<LoginProvider>().logout(context);
                    },
                    icon: const Icon(
                      Icons.power_settings_new_sharp,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              if (context.read<LoginProvider>().uploadedFiles.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green.shade300),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Image.network(
                                    context
                                        .watch<LoginProvider>()
                                        .uploadedFiles[index]
                                        .url,
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    alignment: Alignment.center,
                                    child: Text(
                                        context
                                            .watch<LoginProvider>()
                                            .uploadedFiles[index]
                                            .title,
                                        style: const TextStyle(
                                            color: Colors.white)))
                              ],
                            ),
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount:
                          context.watch<LoginProvider>().uploadedFiles.length),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
