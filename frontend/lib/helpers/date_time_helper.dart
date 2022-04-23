import 'package:intl/intl.dart';

String formatTime(String datetime) {
  final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final inputDate = inputFormat.parse(datetime);
  final outputFormat = DateFormat('hh:mm a');
  final outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getCurrentTime() {
  final now = DateTime.now();
  //final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  final formatter = DateFormat('HH:mm:ss');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

DateTime formatStringDateTimeToTime(String datetime) {
  final parsedDate = DateTime.parse(datetime);
  final formatter = DateFormat('HH:mm:ss');
  String formattedTime = formatter.format(parsedDate);
  final parsedTime = DateTime.parse(formattedTime);

  return parsedTime;
}
