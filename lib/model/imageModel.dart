import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel {
  ImageModel({required this.imageFile}) {
    titleController = TextEditingController();
  }

  TextEditingController? titleController;
  XFile? imageFile;
}
