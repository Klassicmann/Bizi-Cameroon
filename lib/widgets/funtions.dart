checktime(DateTime postTime) {
  final timeNow = DateTime.now();

  final days = timeNow.difference(postTime).inDays;
  final hour = timeNow.difference(postTime).inHours;
  final mins = timeNow.difference(postTime).inMinutes;
  final secs = timeNow.difference(postTime).inSeconds;
  final month = postTime.month;
  final year = postTime.year;

  if (hour <= 24 && days == 0) {
    if (timeNow.hour >= postTime.hour) {
      if (secs <= 60) {
        return 'Just now';
      } else if (mins <= 60) {
        return mins.toString() + ' mins ago';
      } else if (hour <= 12) {
        return hour.toString() + ' hours ago';
      } else {
        return 'Today at ' +
            postTime.hour.toString() +
            ':' +
            postTime.minute.toString();
      }
    } else {
      return 'Yesterday at ' +
          postTime.hour.toString() +
          ':' +
          postTime.minute.toString();
    }
  }
  if (hour <= 24 && days == 0) {
    return hour.toString() + ' hours ago';
  } else if (days == 7) {
    return '1 week ago';
  }

  return postTime.day.toString() +
      '/' +
      month.toString() +
      '/' +
      year.toString();
}
