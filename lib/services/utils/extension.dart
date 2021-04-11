extension Extension on Object {
  bool isNullOrEmpty() => this == null || this == '';
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isValidPhone() {
return RegExp(
            r'(^[0-9\-\(\)\/\+\s]{10}?$)')
        .hasMatch(this);
  }
}
// String pattern = r'(^(?:[+0]9)?[0-9]{8,15}$)';
//String pattern = r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{5,19}$)';
      