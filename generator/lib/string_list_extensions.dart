extension StringListExtensions on List<String> {
  bool containsWithCase(String value, bool caseSensitive) {
    for (var item in this) {
      final formattedItem = caseSensitive ? item : item.toUpperCase();
      final formattedValue = caseSensitive ? value : value.toUpperCase();
      if (formattedItem == formattedValue) {
        return true;
      }
    }
    return false;
  }
}
