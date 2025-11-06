import 'department.dart';
import 'schedule.dart';

abstract class Staff {
  final String id;
  String name;
  String gender;
  DateTime dateOfBirth;
  DateTime startDate;
  String contactNumber;
  String email;
  double salary;
  Department? department;
  bool active;
  Schedule? schedule;
  Staff({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.email,
    required this.salary,
    required this.startDate,
    this.department,
    this.active = true,
    this.schedule,
  });

  void displayInfo() {
    print('--- $name Info ---');
    print('ID: $id');
    print('Name: $name');
    print('Gender: $gender');
    print('Date of Birth: ${dateOfBirth.toLocal().toString().split(' ')[0]}');
    print('Contact: $contactNumber');
    print('Email: $email');
    print('Start Date: ${startDate.toLocal().toString().split(' ')[0]}');
    print('Department: ${department?.name ?? "Not assigned"}');
    print('Active: ${active ? "Yes" : "No"}');
    print('Base Salary: ${salary}');
  }

  void updateContact({String? newContact, String? newEmail}) {
    if (newContact != null) {
      contactNumber = newContact;
    }
    if (newEmail != null) {
      email = newEmail;
    }
  }

  void assignSchedule(Schedule newSchedule) {
    schedule = newSchedule;
    print('$name has been assigned to ${newSchedule.shift} shift.');
  }


  bool isAvailable(String day) {
  if (schedule == null) return true;
  return schedule!.isWorkingDay(day);
}

  double calculateMonthlySalary();

  @override
  String toString() {
    return 'Staff{id: $id, name: $name, gender: $gender, dateOfBirth: $dateOfBirth, contactNumber: $contactNumber, email: $email, salary: $salary, department: $department, active: $active, schedule: $schedule}';
  }
}
