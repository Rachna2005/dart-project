//lib/ui/ui.dart
import 'dart:io';
import '../domain/hospital.dart';
import 'staff_menu.dart';
import 'department_menu.dart';
import 'schedule_menu.dart';
import 'payroll_menu.dart';

class ConsoleUI {
  final Hospital hospital = Hospital(
    name: "sunshine Hospital",
    address: "Phnom Penh",
  );

  late StaffMenu staffMenu = StaffMenu(hospital);
  late DepartmentMenu departmentMenu = DepartmentMenu(hospital);
  late ScheduleMenu scheduleMenu = ScheduleMenu(hospital);
  late PayrollMenu payrollMenu = PayrollMenu(hospital);

  void start() {
    // Load staff from file on startup
    // var staffList = staffRepo.readStaff();
    // for (var s in staffList) {
    //   _addToAnyDepartment(s);
    // }
    while (true) {
      print("\n Welcome to ${hospital.name} Staff Management System");
      print("==============================================");
      print("1. Manage Staff");
      print("2. Manage Departments");
      print("3. Manage Schedules");
      print("4. Payroll & Reports");
      print("0. Exit");
      stdout.write(" Choose an option: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          staffMenu.manageStaffMenu();
          break;
        case '2':
          departmentMenu.manageDepartmentMenu();
          break;
        case '3':
          scheduleMenu.manageScheduleMenu();
          break;
        case '4':
          payrollMenu.payrollMenu();
          break;
        case '0':
          print(" Exiting... Goodbye!");
          return;
        default:
          print(" Invalid choice. Try again!");
      }
    }
  }
 
}

