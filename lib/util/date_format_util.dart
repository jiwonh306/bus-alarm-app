String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(
      '${dateTimeString.substring(0, 4)}-${dateTimeString.substring(4, 6)}-${dateTimeString.substring(6, 8)} ${dateTimeString.substring(8, 10)}:${dateTimeString.substring(10, 12)}:${dateTimeString.substring(12, 14)}');
  return '${dateTime.hour}시 ${dateTime.minute}분';
}
