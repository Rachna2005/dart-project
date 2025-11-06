enum Shift { Morning, Evening, Night }

// Morning 7 AM – 3 PM
// Evening 3 PM – 11 PM
// Night 11 PM – 7 AM

class Schedule {
  int weekNumber;
  Shift shift;
  List<String> daysOff; // ['Sat','Sun']

  Schedule(
      {required this.weekNumber, required this.shift, List<String>? daysOff})
      : daysOff = daysOff ?? ['Sat', 'Sun'];

  // For nurses: rotate shift in order Morning - Afternoon - Night - Morning ...
  void rotateShift() {
    switch (shift) {
      case Shift.Morning:
        shift = Shift.Evening;
        break;
      case Shift.Evening:
        shift = Shift.Night;
        break;
      case Shift.Night:
        shift = Shift.Morning;
        break;
    }
    weekNumber += 1;
  }

  bool isWorkingDay(String day) => !daysOff.contains(day);

  @override
  String toString() {
    return 'Week $weekNumber - $shift - Days off: ${daysOff.join(', ')}';
  }
}
