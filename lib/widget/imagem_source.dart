import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//stless
//stfull

class ImagemSource extends StatelessWidget {
  final Function(File) onImagemSelecionada;
  ImagemSource({this.onImagemSelecionada});

  void imageSelecionar(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square]);
          onImagemSelecionada(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                FlatButton(
                  child: Text("Câmera"),
                  onPressed: () async {
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    imageSelecionar(image);
                  },
                ),
                FlatButton(
                  child: Text("Galeria"),
                  onPressed: () async {
                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    imageSelecionar(image);
                  },
                )
              ],
            ));
  }
}
