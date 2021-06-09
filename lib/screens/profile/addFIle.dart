import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/profile/documentModel.dart';

import 'dart:async';
import 'dart:io';

class AddFileScreen extends StatefulWidget {
  final Document document;
  AddFileScreen(this.document);
  @override
  _AddFileScreenState createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  bool _isAlert = false;
  bool _isPreview = false;
  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source, {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        //maxWidth: maxWidth,
        //maxHeight: maxHeight,
        //imageQuality: quality,
      );
      setState(() {
        _imageFile = pickedFile;
        _isPreview = true;
        _isAlert = false;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Semantics(
          child: Image.file(
            File(_imageFile!.path),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 1.31,
            width: MediaQuery.of(context).size.width,
          ),
          label: 'image_picker_example_picked_image');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.document.title)),
      backgroundColor: _isAlert
          ? Color(0xfff0f0f0)
          : Theme.of(context).scaffoldBackgroundColor,
      body: !_isPreview
          ? Column(children: [
              if (widget.document.subtitle != null)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(widget.document.subtitle!, style: subTitle),
                ),
              if (widget.document.detail != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(widget.document.detail!),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.camera_roll_outlined,
                  size: 120,
                  color: Colors.blueGrey,
                ),
              ),
              Spacer(flex: 2),
              if (_isAlert) _selectBoxWidget(),
              if (!_isAlert)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isAlert = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text('Take Photo'),
                            ))),
                  ),
                )
            ])
          : Column(children: [
              Center(
                child: defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();
                            case ConnectionState.done:
                              return _previewImage();
                            default:
                              if (snapshot.hasError) {
                                return Text(
                                  'Pick image error: ${snapshot.error}}',
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return Text(
                                    'You have not picked an image hahaah');
                              }
                          }
                        },
                      )
                    : _previewImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            //todo upload code
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text('Upload Photo'),
                          ))),
                ),
              )
            ]),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _selectBoxWidget() {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Choose documents to be upload.',
                  style: subTitle.copyWith(fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16)),
                        child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () => _onImageButtonPressed(
                                ImageSource.camera,
                                context: context)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Camera'),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16)),
                        child: IconButton(
                            icon: Icon(
                              Icons.photo_library,
                              color: Colors.white,
                            ),
                            onPressed: () => _onImageButtonPressed(
                                ImageSource.gallery,
                                context: context)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Files'),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
