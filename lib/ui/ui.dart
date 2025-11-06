//lib/ui/ui.dart
import 'dart:io';
import '../domain/hospital.dart';
import '../domain/department.dart';
import '../domain/doctor.dart';
import '../domain/nurse.dart';
import '../domain/administrative_staff.dart';
import '../domain/schedule.dart';
import '../domain/staff.dart';
import 'package:my_first_project/data/id_generator.dart';
import '../data/staffRepository.dart';

class ConsoleUI {
  final Hospital hospital = Hospital(
    name: "City Hospital",
    address: "Phnom Penh",
  );

  final StaffRepository staffRepo = StaffRepository(filePath: 'data/assets/staff.json');


  void start() {
    // Load staff from file on startup
    var staffList = staffRepo.readStaff();
    for (var s in staffList) {
      _addToAnyDepartment(s);
    }
    while (true) {
      print("\n🏥 Welcome to ${hospital.name} Staff Management System");
      print("==============================================");
      print("1. Manage Staff");
      print("2. Manage Departments");
      print("3. Manage Schedules");
      print("4. Payroll & Reports");
      print("0. Exit");
      stdout.write("👉 Choose an option: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          manageStaffMenu();
          break;
        case '2':
          manageDepartmentMenu();
          break;
        case '3':
          manageScheduleMenu();
          break;
        case '4':
          payrollMenu();
          break;
        case '0':
          print("👋 Exiting... Goodbye!");
          return;
        default:
          print("❌ Invalid choice. Try again!");
      }
    }
  }

  // ================= STAFF MENU =================
  void manageStaffMenu() {
    while (true) {
      print("\n===Manage Staff===");
      print("1. Add new staff");
      print("2. View all staff");
      print("3. Update staff contact/email");
      print("4. Assign staff to department");
      print("5. Remove staff");
      print("0. Back");
      stdout.write("👉 Choose: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          addNewStaff();
          break;
        case '2':
          viewAllStaff();
          break;
        case '3':
          updateStaffContact();
          break;
        case '4':
          assignStaffToDepartment();
          break;
        case '5':
          removeStaff();
          break;
        case '0':
          return;
        default:
          print("❌ Invalid choice!");
      }
    }
  }

  void addNewStaff() {
    print("\nAdd New Staff");
    print("1. Doctor");
    print("2. Nurse");
    print("3. Administrative Staff");
    stdout.write("Choose type: ");
    String? type = stdin.readLineSync();

    String id = '';
    switch (type) {
      case '1':
        id = IdGenerator.generateDoctorId();
        break;
      case '2':
        id = IdGenerator.generateNurseId();
        break;
      case '3':
        id = IdGenerator.generateAdminId();
        break;
      default:
        print("Invalid staff type!");
    }
    print("ID: $id");
    stdout.write("Name: ");
    String name = stdin.readLineSync()!;
    stdout.write("Gender: ");
    String gender = stdin.readLineSync()!;
    stdout.write("Date of Birth (YYYY-MM-DD): ");
    DateTime dob = DateTime.parse(stdin.readLineSync()!);
    stdout.write("Contact: ");
    String contact = stdin.readLineSync()!;
    stdout.write("Email: ");
    String email = stdin.readLineSync()!;
    stdout.write("Base Salary: ");
    double salary = double.parse(stdin.readLineSync()!);
    DateTime startDate = DateTime.now();

    switch (type) {
      case '1':
        stdout.write("Specialization: ");
        String specialization = stdin.readLineSync()!;
        stdout.write("Years of Experience: ");
        int exp = int.parse(stdin.readLineSync()!);
        var doctor = Doctor(
          id: id,
          name: name,
          gender: gender,
          dateOfBirth: dob,
          contactNumber: contact,
          email: email,
          salary: salary,
          startDate: startDate,
          specialization: specialization,
          yearsOfExperience: exp,
        );
        _addToAnyDepartment(doctor);
        staffRepo.writeStaff(hospital.getAllStaff());
        break;

      case '2':
        print("Choose Nurse Level: 1.Junior 2.Senior 3.Head");
        int lvl = int.parse(stdin.readLineSync()!);
        NurseLevel level = NurseLevel.values[lvl - 1];
        var nurse = Nurse(
          id: id,
          name: name,
          gender: gender,
          dateOfBirth: dob,
          contactNumber: contact,
          email: email,
          salary: salary,
          startDate: startDate,
          level: level,
        );
        _addToAnyDepartment(nurse);
        staffRepo.writeStaff(hospital.getAllStaff());
        break;

      case '3':
        print(
            "Choose Admin Position: 1.Receptionist 2.HR 3.Accountant 4.ITSupport 5.Manager");
        int pos = int.parse(stdin.readLineSync()!);
        AdminPosition position = AdminPosition.values[pos - 1];
        var admin = AdministrativeStaff(
          id: id,
          name: name,
          gender: gender,
          dateOfBirth: dob,
          contactNumber: contact,
          email: email,
          salary: salary,
          startDate: startDate,
          position: position,
        );
        _addToAnyDepartment(admin);
        staffRepo.writeStaff(hospital.getAllStaff());
        break;

      default:
        print("❌ Invalid staff type!");
    }
  }

  void viewAllStaff() {
    var staffList = hospital.getAllStaff();
    if (staffList.isEmpty) {
      print("No staff yet.");
      return;
    }

    // Column titles
    List<String> headers = [
      "ID",
      "Name",
      "Gender",
      "Date Birth",
      "Start Date",
      "Contact",
      "Email",
      "Department",
      "Salary",
      "Role/Details"
    ];

    // Calculate max width for each column
    List<int> colWidths =
        List.generate(headers.length, (i) => headers[i].length);

    for (var s in staffList) {
      List<String> row = [
        s.id.toString(),
        s.name,
        s.gender,
        '${s.dateOfBirth.year}-${s.dateOfBirth.month.toString().padLeft(2, '0')}-${s.dateOfBirth.day.toString().padLeft(2, '0')}',
        '${s.startDate.year}-${s.startDate.month.toString().padLeft(2, '0')}-${s.startDate.day.toString().padLeft(2, '0')}',
        s.contactNumber,
        s.email,
        s.department?.name ?? "Not assigned",
        '\$${s.calculateMonthlySalary().toStringAsFixed(2)}',
        _getStaffExtraInfo(s),
      ];

      for (int i = 0; i < row.length; i++) {
        if (row[i].length > colWidths[i]) colWidths[i] = row[i].length;
      }
    }

    // Helper to print a row
    void printRow(List<String> row) {
      String line = '|';
      for (int i = 0; i < row.length; i++) {
        line += ' ${row[i].padRight(colWidths[i])} |';
      }
      print(line);
    }

    // Print table
    // Header
    print('-' * (colWidths.reduce((a, b) => a + b) + headers.length * 3 + 1));
    printRow(headers);
    print('-' * (colWidths.reduce((a, b) => a + b) + headers.length * 3 + 1));

    // Rows
    for (var s in staffList) {
      List<String> row = [
        s.id.toString(),
        s.name,
        s.gender,
        '${s.dateOfBirth.year}-${s.dateOfBirth.month.toString().padLeft(2, '0')}-${s.dateOfBirth.day.toString().padLeft(2, '0')}',
        '${s.startDate.year}-${s.startDate.month.toString().padLeft(2, '0')}-${s.startDate.day.toString().padLeft(2, '0')}',
        s.contactNumber,
        s.email,
        s.department?.name ?? "Not assigned",
        '\$${s.calculateMonthlySalary().toStringAsFixed(2)}',
        _getStaffExtraInfo(s),
      ];
      printRow(row);
    }

    // Footer
    print('-' * (colWidths.reduce((a, b) => a + b) + headers.length * 3 + 1));
  }

// Helper function to get role-specific info
  String _getStaffExtraInfo(Staff s) {
    if (s is Doctor) {
      return 'Doctor | ${s.specialization} | ${s.yearsOfExperience} yrs';
    } else if (s is Nurse) {
      return 'Nurse | ${s.level.name}';
    } else if (s is AdministrativeStaff) {
      return 'Admin | ${s.position.name}';
    } else {
      return '';
    }
  }

  void updateStaffContact() {
    stdout.write("Enter staff ID: ");
    // int id = int.parse(stdin.readLineSync()!);
    String id = stdin.readLineSync()!;
    var staff = hospital.getAllStaff().firstWhere((s) => s.id == id,
        orElse: () => throw Exception("Staff not found"));
    stdout.write("New contact (or leave blank): ");
    String? contact = stdin.readLineSync();
    stdout.write("New email (or leave blank): ");
    String? email = stdin.readLineSync();
    staff.updateContact(
      newContact: contact!.isEmpty ? null : contact,
      newEmail: email!.isEmpty ? null : email,
    );
    print("==> Contact info updated.");
    staffRepo.writeStaff(hospital.getAllStaff()); 
  }

  void assignStaffToDepartment() {
    stdout.write("Enter staff ID: ");
    // int id = int.parse(stdin.readLineSync()!);
    String id = stdin.readLineSync()!;
    var staff = hospital.getAllStaff().firstWhere((s) => s.id == id,
        orElse: () => throw Exception("Staff not found"));

    stdout.write("Enter department name: ");
    String deptName = stdin.readLineSync()!;
    var department = hospital.findDepartmentByName(deptName);
    if (department != null) {
      hospital.addStaffToDepartment(staff, department);
      staffRepo.writeStaff(hospital.getAllStaff());
    }
  }

  void removeStaff() {
    stdout.write("Enter staff ID to remove: ");
    // int id = int.parse(stdin.readLineSync()!);
    String id = stdin.readLineSync()!;
    for (var d in hospital.departments) {
      var toRemove = d.staffMembers.where((s) => s.id == id).toList();
      if (toRemove.isNotEmpty) {
        d.removeStaff(toRemove.first);
        print("==> Staff removed.");
        staffRepo.writeStaff(hospital.getAllStaff());
        return;
      }
    }
    print("❌ Staff not found.");
  }

  void _addToAnyDepartment(Staff staff) {
    if (hospital.departments.isEmpty) {
      // print("⚠ No departments yet. Creating 'General' department.");
      hospital
          .addDepartment(Department(id: 1, name: "General", staffMembers: []));
    }
    hospital.departments.first.addStaff(staff);
    print(
        "==> Added ${staff.name} to ${hospital.departments.first.name} department.");
  }

  // ================= DEPARTMENT MENU =================
  void manageDepartmentMenu() {
    while (true) {
      print("\n🏢 Manage Departments");
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
          print("❌ Invalid choice!");
      }
    }
  }

  // ================= SCHEDULE MENU =================
  void manageScheduleMenu() {
    while (true) {
      print("\n📅 Manage Schedules");
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
          print("❌ Invalid choice!");
      }
    }
  }

  void assignSchedule() {
    stdout.write("Enter staff ID: ");
    // int id = int.parse(stdin.readLineSync()!);
    String id = stdin.readLineSync()!;
    var staff = hospital.getAllStaff().firstWhere((s) => s.id == id,
        orElse: () => throw Exception("Staff not found"));
    stdout.write("Week number: ");
    int week = int.parse(stdin.readLineSync()!);
    print("Shift: 1.Morning 2.Afternoon 3.Night");
    int shiftNum = int.parse(stdin.readLineSync()!);
    Shift shift = Shift.values[shiftNum - 1];
    var schedule = Schedule(weekNumber: week, shift: shift);
    hospital.assignShiftToStaff(staff, schedule);
    staffRepo.writeStaff(hospital.getAllStaff());
  }

  void rotateNurseShifts() {
    var nurses = hospital.getStaffByRole("Nurse");
    for (var n in nurses) {
      n.schedule?.rotateShift();
    }
    print("==> All nurse shifts rotated for next week.");
    staffRepo.writeStaff(hospital.getAllStaff());
  }

  void viewSchedules() {
    for (var s in hospital.getAllStaff()) {
      print("${s.name} → ${s.schedule ?? 'No schedule assigned'}");
    }
  }

  // ================= PAYROLL MENU =================
  void payrollMenu() {
    while (true) {
      print("\n💵 Payroll & Reports");
      print("==========================");
      print("1. Show salary for each staff");
      print("2. Show total salary by department");
      print("3. Show top 3 highest paid staff");
      print("0. Back");
      stdout.write("👉 Choose: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          hospital.getAllStaff().forEach((s) {
            print("${s.name} - \$${s.calculateMonthlySalary()}");
          });
          break;
        case '2':
          for (var d in hospital.departments) {
            double total = d.staffMembers
                .fold(0, (sum, s) => sum + s.calculateMonthlySalary());
            print("${d.name}: \$${total}");
          }
          break;
        case '3':
          var sorted = hospital.getAllStaff()
            ..sort((a, b) => b
                .calculateMonthlySalary()
                .compareTo(a.calculateMonthlySalary()));
          for (var i = 0; i < sorted.length && i < 3; i++) {
            print(
                "${i + 1}. ${sorted[i].name} - \$${sorted[i].calculateMonthlySalary()}");
          }
          break;
        case '0':
          return;
        default:
          print("❌ Invalid choice!");
      }
    }
  }
}
