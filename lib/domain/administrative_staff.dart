import 'staff.dart';
import 'department.dart';
import 'schedule.dart';

enum AdminPosition { Receptionist, HR, Accountant, ITSupport, Manager }

class AdministrativeStaff extends Staff {
  AdminPosition position;

  AdministrativeStaff({
    required String id,
    required String name,
    required String gender,
    required DateTime dateOfBirth,
    required String contactNumber,
    required String email,
    required double salary,
    required DateTime startDate,
    required this.position,
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
    print('Position: $position');
    print('Monthly Salary: \$${calculateMonthlySalary().toStringAsFixed(2)}');
  }

  @override
  double calculateMonthlySalary() {
    switch (position) {
      case AdminPosition.Receptionist:
        salary = 1500;
        break;
      case AdminPosition.HR:
        salary = 2000;
        break;
      case AdminPosition.Accountant:
        salary = 2200;
        break;
      case AdminPosition.ITSupport:
        salary = 2300;
        break;
      case AdminPosition.Manager:
        salary = 3000;
        break;
    }
    return salary;
  }
}
