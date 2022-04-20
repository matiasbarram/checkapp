import 'package:intl/intl.dart';

String apiFomrmatToTime(String datetime) {
  final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final inputDate = inputFormat.parse(datetime);
  final outputFormat = DateFormat('hh:mm a');
  final outputDate = outputFormat.format(inputDate);
  return outputDate;
}
