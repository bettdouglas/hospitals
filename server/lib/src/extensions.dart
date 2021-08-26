extension CapExtension on String {
  String get capitalizeFirstLetter => '${this[0].toUpperCase()}${substring(1)}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach {
    final splitBySpace = split(' ');
    // return split(' ').map((str) => str.trim().inCaps).join(' ');
    return splitBySpace
        .map((e) => e.isEmpty ? '' : e.toLowerCase().capitalizeFirstLetter)
        .join(' ');
  }
}

class GetExtensions {}
