import 'staff.dart';
import 'department.dart';
import 'schedule.dart';
class Doctor extends Staff {
  String specialization;
  int yearsOfExperience;

  Doctor({
    required String id,
    required String name,
    required String gender,
    required DateTime dateOfBirth,
    required String contactNumber,
    required String email,
    required double salary,
    required DateTime startDate,
    required this.specialization,
    required this.yearsOfExperience,
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
    print('Specialization: $specialization');
    print('Years of Experience: $yearsOfExperience');
    print('Monthly Salary: \$${calculateMonthlySalary().toStringAsFixed(2)}');
  }
  @override
  double calculateMonthlySalary() {
    return salary + (200 * yearsOfExperience);
  }
}

