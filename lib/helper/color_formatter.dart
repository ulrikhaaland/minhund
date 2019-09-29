class ColorFormatter {
  static int hexToInt(String hex) {
    return int.parse("0xFF" + hex.replaceFirst("#", ""));
  }
}
