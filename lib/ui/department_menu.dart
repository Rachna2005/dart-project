import 'dart:io';
import '../domain/hospital.dart';
import '../domain/department.dart';
import '../domain/doctor.dart';
import '../domain/nurse.dart';
import '../domain/administrative_staff.dart';
import '../domain/staff.dart';

class DepartmentMenu {
  Hospital hospital;
  DepartmentMenu(this.hospital);

  void manageDepartmentMenu() {
    while (true) {
      print("\n Manage Departments");
      print("==========================");
      print("1. Add new department");
      print("2. View all departments");
      print("0. Back");
      stdout.write(" Choose: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          stdout.write("Department ID: ");
          int id = int.parse(stdin.readLineSync()!);
          stdout.write("Department Name: ");
          String name = stdin.readLineSync()!;
          hospital
              .addDepartment(Department(id: id, name: name, staffMembers: []));
          break;
        case '2':
          for (var d in hospital.departments) {
            d.displayDepartmentInfo();
          }
          break;
        case '0':
          return;
        default:
          print(" Invalid choice!");
      }
    }
  }


  String getStaffRole(Staff staff) {
    if (staff is Doctor) return "Doctor";
    if (staff is Nurse) return "Nurse";
    if (staff is AdministrativeStaff) return "Administrative Staff";
    return "Staff";
  }

  String getStaffDetails(Staff staff) {
    if (staff is Doctor) {
      return "Specialization: ${staff.specialization} | Experience: ${staff.yearsOfExperience} years";
    } else if (staff is Nurse) {
      return "Level: ${staff.level} | Schedule: ${staff.schedule ?? 'Not assigned'}";
    } else if (staff is AdministrativeStaff) {
      return "Position: ${staff.position}";
    }
    return "";
  }
}
