import 'package:flutter/material.dart';

class ColorCustom {
  static List<Color> orenGradient = [
    _hexColor("#ffdb43"),
    _hexColor("#f3d865")
  ];
  static List<Color> orenGradient1 = [
    _hexColor("#ec9f05"),
    _hexColor("#f3d865")
  ];
  static List<Color> redGradient1 = [
    _hexColor("#FF0000"),
    _hexColor("#FF2A00"),
    _hexColor("#FF002A")
  ];
  static List<Color> blueGradient = [
    _hexColor("#0000FF"),
    _hexColor("#1F1FFF"),
    _hexColor("#4949FF")
  ];
  static List<Color> blueGradient2 = [
    _hexColor("#085078"),
    _hexColor("#85D8CE")
  ];

  static List<Color> blueGradient1 = [
    _hexColor("#52a6ff"),
    _hexColor("#52a6ff")
  ];

  static Color blueColor = _hexColor("#BCDCE9");
  static Color primaryBlue = _hexColor("#0062A7");
  static List<Color> light1 = [_hexColor("#BFD9FF"), _hexColor("#BFD9FF")];
  static List<Color> light2 = [_hexColor("#EBEDF1"), _hexColor("#EBEDF1")];
  static List<Color> light3 = [_hexColor("#FCC5A1"), _hexColor("#FCC5A1")];

  static List<Color> pastelGradient = [
    _hexColor("#bfded5"),
    _hexColor("#bfded5")
  ];
  static Color pastel = _hexColor("#bfded5");

  static List<Color> darkGreyGradient = [
    _hexColor("#7c8f89"),
    _hexColor("#7c8f89")
  ];
  static Color darkGrey = _hexColor("#7c8f89");

  static List<Color> lightGreyGradient = [
    _hexColor("#c9d6d2"),
    _hexColor("#c9d6d2")
  ];
  static Color lightGrey = _hexColor("#c9d6d2");

  static List<Color> redGradient = [_hexColor("#ff3636"), _hexColor("#ff3636")];
  static Color red = _hexColor("#ff3636");

  static List<Color> whiteGradient = [
    _hexColor("#FFFFFF"),
    _hexColor("#FFFFFF")
  ];

  static Color _hexColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Tambahkan alpha default jika tidak ada
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
