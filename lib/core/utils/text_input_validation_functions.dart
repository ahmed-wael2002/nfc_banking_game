class TextInputValidationFunctios{
  static bool isEmailValid(String email){
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isPasswordValid(String password){
    return password.length >= 6;
  }

  static bool isNameValid(String name){
    return name.length >= 3;
  }


  bool validateEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool validateName(String name) {
    return RegExp(r'^[a-zA-Z\s-]+$').hasMatch(name);
  }

  bool validatePhoneNumber(String number) {
    return RegExp(r"^\+[1-9]\d{1,14}$").hasMatch(number);
  }

  bool validateAddressLine(String addressLine) {
    return RegExp(r"^[a-zA-Z0-9\s,.'-]{1,100}$").hasMatch(addressLine);
  }

  bool validatePostCode(String postCode) {
    return RegExp(r'^[a-zA-Z0-9\s-]+$').hasMatch(postCode);
  }

  bool validateCity(String city) {
    return RegExp(r'^[a-zA-Z\s-]+$').hasMatch(city);
  }
  static bool isPhoneNumberValid(String phoneNumber){
    return phoneNumber.length == 10;
  }

  static bool isPinCodeValid(String pinCode){
    return pinCode.length == 6;
  }


  static bool isAmountValid(String amount){
    return RegExp(r'^[0-9]*$').hasMatch(amount);
  }

  static bool isDateValid(String date){
    return RegExp(r'^[0-9]{2}/[0-9]{2}/[0-9]{4}$').hasMatch(date);
  }

  static bool isTimeValid(String time){
    return RegExp(r'^[0-9]{2}:[0-9]{2}$').hasMatch(time);
  }

  static bool isURLValid(String url){
    return RegExp(r'^http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?$').hasMatch(url);
  }

  static bool isAddressValid(String address){
    return address.length >= 10;
  }


}