String convertSecondsToMinutes(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  if (minutes > 0) {
    return '$minutes분 $remainingSeconds초 후 도착';
  } else {
    return '곧 도착';
  }
}