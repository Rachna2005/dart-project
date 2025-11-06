import 'dart:io';
import '../domain/hospital.dart';
import '../domain/schedule.dart';

class ScheduleMenu {
  Hospital hospital;
  ScheduleMenu(this.hospital);
 
  void manageScheduleMenu() {
    while (true) {
      print("\n Manage Schedules");
      print("==========================");
      print("1. Assign schedule to staff");
      print("2. Rotate nurse shifts");
      print("3. View staff schedules");
      print("0. Back");
      stdout.write(" Choose: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          assignSchedule();
          break;
        case '2':
          rotateNurseShifts();
          break;
        case '3':
          viewSchedules();
          break;
        case '0':
          return;
        default:
          print(" Invalid choice!");
      }
    }
  }

  void assignSchedule() {
    stdout.write("Enter staff ID: ");
    int id = int.parse(stdin.readLineSync()!);
    var staff = hospital.getAllStaff().firstWhere((s) => s.id == id,
        orElse: () => throw Exception("Staff not found"));
    stdout.write("Week number: ");
    int week = int.parse(stdin.readLineSync()!);
    print("Shift: 1.Morning 2.Afternoon 3.Night");
    int shiftNum = int.parse(stdin.readLineSync()!);
    Shift shift = Shift.values[shiftNum - 1];
    var schedule = Schedule(weekNumber: week, shift: shift);
    hospital.assignShiftToStaff(staff, schedule);
  }

  void rotateNurseShifts() {
    var nurses = hospital.getStaffByRole("Nurse");
    for (var n in nurses) {
      n.schedule?.rotateShift();
    }
    print(" All nurse shifts rotated for next week.");
  }

  void viewSchedules() {
    for (var s in hospital.getAllStaff()) {
      print("${s.name} → ${s.schedule ?? 'No schedule assigned'}");
    }
  }
}