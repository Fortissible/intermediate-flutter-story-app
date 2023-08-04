import 'package:intl/intl.dart';


String convertDateTime(String? rawDateTime){
  if (rawDateTime == null) {
    return "";
  }

  final dateTime = DateTime.parse(rawDateTime);

  final format = DateFormat('yyyy-MM-dd HH:mm:ss');
  final clockString = format.format(dateTime);

  return clockString; // 07:18 AM
}