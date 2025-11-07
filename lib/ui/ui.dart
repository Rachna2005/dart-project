
import 'dart:io';
import '../domain/hospital.dart';
import 'staff_menu.dart';
import 'department_menu.dart';
import 'schedule_menu.dart';
import 'payroll_menu.dart';
import '../data/staffRepository.dart';
import '../data/DepartmentRepository.dart';

class ConsoleUI {
  final Hospital hospital = Hospital(
    name: "Sunshine Hospital",
    address: "Phnom Penh",
  );

  // Repositories
  final StaffRepository staffRepo =
      StaffRepository(filePath: 'data/assets/staff.json');
  final DepartmentRepository deptRepo =
      DepartmentRepository(filePath: 'data/assets/departments.json');

  late StaffMenu staffMenu = StaffMenu(hospital);
  late DepartmentMenu departmentMenu = DepartmentMenu(hospital);
  late ScheduleMenu scheduleMenu = ScheduleMenu(hospital);
  late PayrollMenu payrollMenu = PayrollMenu(hospital);

  void start() {
    // ================ Load saved data ================
    print("Loading data...");
    var staffList = staffRepo.readStaff();
    for (var s in staffList) {
      hospital.addStaff(s);
    }

    var departments = deptRepo.readDepartments(staffList);
    for (var d in departments) {
      hospital.addDepartment(d);
    }
    print("Data loaded successfully!");

    // ===================== Main Menu =====================
    while (true) {
      print("\nWelcome to ${hospital.name} Staff Management System");
      print("==============================================");
      print("1. Manage Staff");
      print("2. Manage Departments");
      print("3. Manage Schedules");
      print("4. Payroll & Reports");
      print("0. Exit");
      stdout.write("Choose an option: ");
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
          _exitProgram();
          return;
        default:
          print("Invalid choice. Try again!");
      }
    }
  }

  // ======================= Save data before exit =======================
  void _exitProgram() {
    print("\nSaving data...");
    staffRepo.writeStaff(hospital.getAllStaff());
    deptRepo.writeDepartments(hospital.departments);
    print("Data saved successfully!");
    print("Goodbye!");
  }
}

