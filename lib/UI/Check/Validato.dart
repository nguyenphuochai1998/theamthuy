class Validato {
  // kiem tra la sdt
  static bool isPhoneNumber(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{8,9}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return false;
    } else {
      if (!regExp.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }

  //kiem tra id
  static bool isID(String value) {
    return value != "";
  }

  static bool isName(String value) {
    return value != "";
  }

  // kiem tra la email
  static bool isEmail(String value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return emailValid;
  }

  // kiem tra mat khau
  static bool isPass(String value) {
    return value.length >= 6;
  }

  // kiem tra 2 pass
  static bool isPassAOk(String pass, String passA) {
    return pass == passA;
  }
}
