import 'package:flutter/material.dart';

enum DocumentStage { attention, redy, done, pending }

class Document {
  final String title;
  final String subtitle;
  final DocumentStage stage;
  final VoidCallback onPressed;
  final String detail;

  const Document(
      {@required this.title,
      this.subtitle,
      @required this.stage,
      this.onPressed,
      this.detail});
}

const documents = [
  Document(
      title: 'Profile Picture',
      stage: DocumentStage.done,
      subtitle: "Upload your recent photo"),
  Document(
      title: 'Identity Documents',
      stage: DocumentStage.attention,
      subtitle: "Upload your photo of your Citizenship",
      detail: 'Please  make sure we can real all of the details easily.'),
  Document(
      title: 'Driving License',
      stage: DocumentStage.redy,
      subtitle: 'Take a photo of your Driving License',
      detail: 'Please  make sure we can real all of the details easily.'),
  Document(
      title: 'Vehicle Insurance',
      stage: DocumentStage.redy,
      subtitle: 'Take a photo of your Vehicle Insurance'),
  Document(
      title: "Driving Permit",
      stage: DocumentStage.redy,
      subtitle: 'Take a photo of your Vehicle Insurance')
];
