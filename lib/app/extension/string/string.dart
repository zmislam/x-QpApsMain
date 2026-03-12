extension StringExtensions on String {
  String get capitalizeFirst =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);


  bool endsWithAny(List<String> suffixes) {
    for (var suffix in suffixes) {
      if (toLowerCase().endsWith(suffix)) {
        return true;
      }
    }
    return false;
  }

  String get capitalizeFirstOfEach {
    if (isEmpty) {
      return '';
    }
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String capitalizeAndReplace(String? input) {
    if (input == null) return '';

    String processedString = input.replaceAll('_', ' ');

    List<String> words = processedString.toLowerCase().split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = '${words[i][0].toUpperCase()}${words[i].substring(1)}';
      }
    }
    processedString = words.join(' ');

    return processedString;
  }

    String get ensureHttpScheme {
    if (startsWith('http://') && startsWith('https://')) {
      return 'https://$this';
    }
    return this;
  }
}
