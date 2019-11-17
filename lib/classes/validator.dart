

class Validator {
//  static String validateEmail(String value) {
//    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return 'Please enter a valid email address.';
//    else
//      return null;
//  }

  static String validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

//  static String validateName(String value) {
//    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return 'Please enter a name.';
//    else
//      return null;
//  }
//
//  static String validateNumber(String value) {
//    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
//      return 'Please enter a number.';
//    else
//      return null;
//  }
  static String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  static String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if(value.length != 8){
      return "Mobile number must 8 digits";
    }else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  static String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
  }

  static String validateEmpty(String value) {
    if (value.length == 0) {
      return "Job Title is Required";
    }
    else {
      return null;
    }
  }

  static String validateJobTitle(String value) {
    if (value.length == 0) {
      return "Job Title is Required";
    }
    else {
      return null;
    }
  }

  static String validateDescription(String value) {
    if (value.length == 0) {
      return "Description is Required";
    }
    else {
      return null;
    }
  }

  static String validateAddress(String value) {
    if (value.length == 0) {
      return "Address is Required";
    }
    else {
      return null;
    }
  }

  static String validateCountry(String value) {
    if (value.length == 0) {
      return "Country is Required";
    }
    else {
      return null;
    }
  }

  static String validateState(String value) {
    if (value.length == 0) {
      return "State is Required";
    }
    else {
      return null;
    }
  }

  static String validatePayout(String value) {
    if (value.length == 0) {
      return "Payout is Required";
    }
    else {
      return null;
    }
  }


}
