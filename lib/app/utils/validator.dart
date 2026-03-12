RegExp passwordValidationRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

RegExp amountValidationRegex = RegExp(r'^\d+(\.\d{1,2})?$');

class ValidatorClass {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp('^[a-zA-Z0-9_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter password';
    } else if (!passwordValidationRegex.hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  String? validateEmpty(String? value) {
    if (value!.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  String? validateOTP(String? value) {
    if (value!.isEmpty) {
      return "This field can't be empty";
    } else if (value.length < 4) {
      return 'Please enter a valid OTP';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    } else if (value.trim().length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  String? validateNumberLength4(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invalid input';
    } else if (value.trim().length < 4) {
      return 'Invalid Input';
    }
    return null;
  }

  String? validateNumberLength16(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invalid input';
    } else if (value.trim().length < 16) {
      return 'Invalid Input';
    }
    return null;
  }

  String? validateSelection(dynamic value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return 'Please make a selection';
    }
    return null;
  }

  String? validateDateTime(String? value) {
    if (value == null) {
      return 'Please select a date';
    }
    return null;
  }

  String? validateEndDateAfterStart(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'Start and End dates are required';
    } else if (!end.isAfter(start)) {
      return 'End date must be after start date';
    }
    return null;
  }

  String? validateMoney(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Enter a valid positive amount';
    }
    return null;
  }

  String? validateMoneyWithFiveMinValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Enter a valid positive amount';
    } else if (double.tryParse(value) == null || double.parse(value) <= 4.99) {
      return 'Minimum transaction amount is \$ 5.00 ';
    }
    return null;
  }

  String? validateAge(String? value, {int min = 10, int max = 100}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter age';
    }
    final int? age = int.tryParse(value);
    if (age == null) {
      return 'Age must be a number';
    } else if (age < min || age > max) {
      return 'Age must be between $min and $max';
    }
    return null;
  }

  String? validateListNotEmpty(List? list) {
    if (list == null || list.isEmpty) {
      return 'At least one item is required';
    }
    return null;
  }

  String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a URL';
    }

    // This regex handles:
    // - Various protocols (http, https, ftp, mailto)
    // - Subdomains (www, blog, store, etc.)
    // - Domains with hyphens
    // - Paths with special characters
    // - Query parameters
    // - Fragment identifiers
    // - Port numbers
    // - File extensions
    const urlPattern = r'^(https?:\/\/|ftp:\/\/|mailto:)?'
        r'([a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,63}|' // domain
        r'localhost|' // localhost
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' // IP address
        r'(:\d+)?' // port
        r'(\/[-a-zA-Z0-9%_.~#+()]*)*' // path
        r'(\?[;&a-zA-Z0-9%_.~+=-]*)?' // query string
        r'(#[-a-zA-Z0-9%_]*)?$'; // fragment

    final regex = RegExp(urlPattern, caseSensitive: false);

    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    } else if (value.length < 10) {
      return 'Description is too short';
    }
    return null;
  }

  String? validateHeadline(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a headline';
    } else if (value.length < 5) {
      return 'Headline is too short';
    }
    return null;
  }
}
