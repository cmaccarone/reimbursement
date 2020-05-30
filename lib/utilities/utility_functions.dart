bool isNumeric(dynamic s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
