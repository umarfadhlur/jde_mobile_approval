import 'package:intl/intl.dart';

export 'size_text.dart';
export 'size_padding.dart';
export 'endpoint.dart';
export 'color.dart';
export 'shared_preference.dart';

String formatDate(String dateString) {
  if (dateString.length != 8) return "Invalid date";

  // Ambil tahun, bulan, dan hari dari string
  String year = dateString.substring(0, 4);
  String month = dateString.substring(4, 6);
  String day = dateString.substring(6, 8);

  // Buat objek DateTime
  DateTime date = DateTime.parse("$year-$month-$day");

  // Format ke MM/dd/yyyy
  return DateFormat("MM/dd/yyyy").format(date);
}
