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
