import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/picked_message_file.dart';

String? emailValidator(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return "Masukkan Email";
  } else if (!regExp.hasMatch(value)) {
    return "Format Email Tidak Valid";
  } else {
    return null;
  }
}

String? passwordValidator(String? value) {
  if (value!.length < 8) {
    return "Masukkan Minimal 8 Digit";
  } else if (value.isEmpty) {
    return "Masukkan Password";
  }
  return null;
}

String? phoneValidator(String? value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return "Nomor Telepon Tidak Boleh Kosong";
  } else if (!regExp.hasMatch(value)) {
    return "Format Tidak Valid";
  }
  return null;
}

String? emptyValidator(String? value) {
  if (value!.isEmpty) {
    return "Field can't be empty";
  }
  return null;
}

Future<PickedMessageFile?> pickImage(bool fromGallery) async {
  final pickedFile = await ImagePicker().pickImage(
    source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    imageQuality: 50,
  );

  if (pickedFile != null) {
    var file = File(pickedFile.path);
    var fileSize = await getFileSize(file);

    return PickedMessageFile(path: pickedFile.path, size: fileSize, file: file);
  } else {
    return null;
  }
}

Future<PickedMessageFile?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    var fileSize = await getFileSize(file);

    return PickedMessageFile(path: file.path, size: fileSize, file: file);
  } else {
    return null;
  }
}

Future<String> getFileSize(File file) async {
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
}

String messageDate(int? datetime) {
  var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
  var today = DateTime.now();

  if (date.day == today.day) {
    return "Today";
  } else if ((today.day - date.day) == 1) {
    return "Yesterday";
  } else {
    return DateFormat("dd MMM yyyy").format(date);
  }
}

String copiedMessage(Message chat, String? name) {
  var date = DateFormat(
    "MM/dd, hh:mm a",
  ).format(DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!));
  return "[$date] $name: ${chat.message}\n";
}
