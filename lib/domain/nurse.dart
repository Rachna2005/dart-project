import 'staff.dart';
import 'department.dart';
import 'schedule.dart';

enum NurseLevel { Junior, Senior, Head }

class Nurse extends Staff {
  NurseLevel level;

  Nurse({
    required int id,
    required String name,
    required String gender,
    required DateTime dateOfBirth,
    required String contactNumber,
    required String email,
    required double salary,
    required DateTime startDate,
    required this.level,
    Department? department,
    bool active = true,
    Schedule? schedule,
  }) : super(
          id: id,
          name: name,
          gender: gender,
          dateOfBirth: dateOfBirth,
          contactNumber: contactNumber,
          email: email,
          salary: salary,
          startDate: startDate,
          department: department,
          active: active,
          schedule: schedule,
        );

  @override
  void displayInfo() {
    super.displayInfo();
    print('Nurse Level: $level');
  }

  @override
  double calculateMonthlySalary() {
    switch (level) {
      case NurseLevel.Junior:
        return salary;
      case NurseLevel.Senior:
        return salary + 100;
      case NurseLevel.Head:
        return salary + 200;
    }
  }
}