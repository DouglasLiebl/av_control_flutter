import 'package:intl/intl.dart';

class DateFormater {

  static String formatDateString(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      try {
        return DateFormat('dd/MM/yyyy').format(
          DateFormat("EEE MMM dd HH:mm:ss 'UTC' yyyy", 'en_US').parse(dateStr)
        );
      } catch (e) {
        return 'Data inválida';
      }
    }
  }

    static String formatISODate(String isoDateStr) {
    try {
      final date = DateTime.parse(isoDateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return 'Data inválida';
    }
  }

  static String addDaysToDate(String dateStr, int days) {
    try {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (e) {
        date = DateFormat("EEE MMM dd HH:mm:ss 'UTC' yyyy", 'en_US').parse(dateStr);
      }
      
      final newDate = date.add(Duration(days: days));
      
      return DateFormat('dd/MM/yyyy').format(newDate);
    } catch (e) {
      return 'Data inválida';
    }
  }
}