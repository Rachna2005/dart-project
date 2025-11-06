import 'dart:io';
import '../domain/hospital.dart';
import '../domain/doctor.dart';
import '../domain/nurse.dart';
import '../domain/administrative_staff.dart';
import '../domain/staff.dart';
import 'package:my_first_project/data/id_generator.dart';

class StaffMenu {
  Hospital hospital;
  StaffMenu(this.hospital);

  void manageStaffMenu() {
    while (true) {
      print("\n Manage Staff");
      print("========================");
      print("1. Add new staff");
      print("2. View all staff");
      print('3. View specific staff');
      print("4. Update staff contact/email");
      print("5. Assign staff to department");
      print("6. Remove staff");
      print("0. Back");
      stdout.write(" Choose: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          addNewStaff();
          break;
        case '2':
          viewAllStaff();
          break;
        case '3':
          viewSpecificStaff();
          break;
        case '4':
          updateStaffContact();
          break;
        case '5':
          assignStaffToDepartment();
          break;
        case '6':
          removeStaff();
          break;
        case '0':
          return;
        default:
          print(" Invalid choice!");
      }
    }
  }

  void addNewStaff() {
    print("\nAdd New Staff");
    print("1. Doctor");
    print("2. Nurse");
    print("3. Administrative Staff");
    print('0. Back');
    stdout.write("Choose type: ");

    String? type;
    while (type == null) {
      stdout.write("Choose type (1-3): ");
      String? input = stdin.readLineSync();
      if (input == '1' || input == '2' || input == '3' || input == '0') {
        type = input;
      } else {
        print(" Invalid staff type! Please try again.");
      }
    }

    if (type == '0') {
      return;
    }

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
      case '0':
        return;
      default:
        print("Invalid staff type!");
    }

    String ValidString(String prompt) {
      while (true) {
        stdout.write(prompt);
        String? input = stdin.readLineSync()?.trim();
        if (input != null && input.isNotEmpty) {
          return input;
        }
        print(" This field cannot be empty! Please try again.");
      }
    }

    DateTime ValidDate(String prompt) {
      while (true) {
        stdout.write(prompt);
        String? input = stdin.readLineSync()?.trim();
        if (input != null && input.isNotEmpty) {
          try {
            DateTime date = DateTime.parse(input);

            if (date.isAfter(DateTime.now())) {
              print(" Date cannot be in the future! Please try again.");
              continue;
            }
            if (date.year < 1900) {
              print(" Date seems too old! Please enter a valid date.");
              continue;
            }
            return date;
          } catch (e) {
            print(
                " Invalid date format! Please use YYYY-MM-DD (e.g., 1990-05-15)");
          }
        } else {
          print(" Date cannot be empty! Please try again.");
        }
      }
    }

    String ValidEmail(String prompt) {
      while (true) {
        stdout.write(prompt);
        String? input = stdin.readLineSync()?.trim();
        if (input != null && input.isNotEmpty) {
          if (input.contains('@') && input.contains('.')) {
            return input;
          } else {
            print(
                " Please enter a valid email address (e.g., name@example.com)");
          }
        } else {
          print(" Email cannot be empty! Please try again.");
        }
      }
    }

    double ValidDouble(String prompt) {
      while (true) {
        stdout.write(prompt);
        String? input = stdin.readLineSync()?.trim();
        if (input != null && input.isNotEmpty) {
          try {
            double value = double.parse(input);
            if (value > 0) {
              return value;
            } else {
              print(" Salary must be greater than 0! Please try again.");
            }
          } catch (e) {
            print(
                " Invalid number! Please enter a valid amount (e.g., 2500.00)");
          }
        } else {
          print(" Salary cannot be empty! Please try again.");
        }
      }
    }

    String name = ValidString("Name: ");
    String gender = ValidString("Gender: ");
    DateTime dob = ValidDate("Date of Birth (YYYY-MM-DD): ");
    String contact = ValidString("Contact: ");
    String email = ValidEmail("Email: ");
    double salary = ValidDouble("Base Salary: ");
    DateTime startDate = ValidDate("Start Date (YYYY-MM-DD): ");

    switch (type) {
      case '1':
        print(
            "Choose Doctor Specialization: 1.Cardiology 2.Neurology 3.Pediatrics 4.Orthopedics 5.Radiology 6.GeneralMedicine");
        print('Choose (1-6): ');
        int spec = int.parse(stdin.readLineSync()!);

        DoctorSpecialization specialization =
            DoctorSpecialization.values[spec - 1];
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
        hospital.addStaff(doctor);
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
        hospital.addStaff(nurse);
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
        hospital.addStaff(admin);
        break;

      default:
        print(" Invalid staff type!");
    }
  }

  void viewSpecificStaff() {
    if (hospital.getAllStaff().isEmpty) {
      print(" No staff available.");
      return;
    }

    print("\n View Specific Staff");
    print("========================");
    print("Search by:");
    print("1. Staff ID");
    print("2. Staff Name");
    stdout.write("Choose search method: ");
    String? searchMethod = stdin.readLineSync()?.trim();

    Staff? staff;

    switch (searchMethod) {
      case '1':
        print("\nAvailable Staff :");
        for (var s in hospital.getAllStaff()) {
          print("  ${s.id} - ${s.name}");
        }
        stdout.write("\nEnter Staff ID: ");
        String? staffId = stdin.readLineSync()?.trim();
        if (staffId == null || staffId.isEmpty) {
          print(" Staff ID cannot be empty.");
          return;
        }
        staff = findStaffById(staffId);
        break;

      case '2':
      
        print("\nAvailable Staff Names:");
        Set<String> uniqueNames = {}; 
        for (var s in hospital.getAllStaff()) {
          uniqueNames.add(s.name);
        }
        uniqueNames.forEach((name) => print("  $name"));

        stdout.write("\nEnter Staff Name: ");
        String? staffName = stdin.readLineSync()?.trim();
        if (staffName == null || staffName.isEmpty) {
          print(" Staff name cannot be empty.");
          return;
        }

        List<Staff> foundStaff = findStaffByName(staffName);
        if (foundStaff.isEmpty) {
          print(" No staff found with name '$staffName'.");
          return;
        } else if (foundStaff.length == 1) {
          staff = foundStaff.first;
        } else {
        
          print("\n Multiple staff found:");
          for (int i = 0; i < foundStaff.length; i++) {
            print(
                "${i + 1}. ${foundStaff[i].name} (ID: ${foundStaff[i].id}) - ${getStaffType(foundStaff[i])}");
          }
          stdout.write("Select staff (number): ");
          String? selection = stdin.readLineSync()?.trim();
          try {
            int index = int.parse(selection!) - 1;
            if (index >= 0 && index < foundStaff.length) {
              staff = foundStaff[index];
            } else {
              print(" Invalid selection.");
              return;
            }
          } catch (e) {
            print(" Invalid input.");
            return;
          }
        }
        break;

      default:
        print(" Invalid choice.");
        return;
    }

    if (staff == null) {
      print(" Staff not found.");
      return;
    }


    displayStaffDetails(staff);
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

  Staff? findStaffById(String id) {
    var allStaff = hospital.getAllStaff();
    for (var staff in allStaff) {
      if (staff.id.toLowerCase() == id.toLowerCase()) {
        return staff;
      }
    }
    return null;
  }

  List<Staff> findStaffByName(String name) {
    var allStaff = hospital.getAllStaff();
    List<Staff> foundStaff = [];

    for (var staff in allStaff) {
      if (staff.name.toLowerCase().contains(name.toLowerCase())) {
        foundStaff.add(staff);
      }
    }
    return foundStaff;
  }

  String getStaffType(Staff staff) {
    if (staff is Doctor) {
      return "Doctor - ${staff.specialization}";
    } else if (staff is Nurse) {
      return "Nurse - ${staff.level}";
    } else if (staff is AdministrativeStaff) {
      return "Admin - ${staff.position}";
    }
    return "Staff";
  }

  void displayStaffDetails(Staff staff) {
    print("\n" + "=" * 60);
    print(" STAFF DETAILS");
    print("=" * 60);
    print("ID: ${staff.id}");
    print("Name: ${staff.name}");
    print("Gender: ${staff.gender}");
    print("Date of Birth: ${_formatDate(staff.dateOfBirth)}");
    print("Start Date: ${_formatDate(staff.startDate)}");
    print("Contact: ${staff.contactNumber}");
    print("Email: ${staff.email}");
    print("Department: ${staff.department?.name ?? "Not assigned"}");
    print(
        "Monthly Salary: \$${staff.calculateMonthlySalary().toStringAsFixed(2)}");

    // Role-specific information
    if (staff is Doctor) {
      print("\n DOCTOR INFORMATION:");
      print("  Role: Doctor");
      print("  Specialization: ${staff.specialization}");
      print("  Years of Experience: ${staff.yearsOfExperience}");
    } else if (staff is Nurse) {
      print("\n NURSE INFORMATION:");
      print("  Role: Nurse");
      print("  Level: ${staff.level}");
      if (staff.schedule != null) {
        print("  Current Schedule: ${staff.schedule}");
      } else {
        print("  Current Schedule: Not assigned");
      }
    } else if (staff is AdministrativeStaff) {
      print("\n ADMINISTRATIVE INFORMATION:");
      print("  Role: Administrative Staff");
      print("  Position: ${staff.position}");
    }

    // Show work duration
    Duration workDuration = DateTime.now().difference(staff.startDate);
    int years = workDuration.inDays ~/ 365;
    int months = (workDuration.inDays % 365) ~/ 30;
    print("\n WORK DURATION: $years years, $months months");

    print("=" * 60);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void updateStaffContact() {
    stdout.write("Enter staff ID: ");
    int id = int.parse(stdin.readLineSync()!);
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
    print(" Contact info updated.");
  }

  void assignStaffToDepartment() {
    stdout.write("Enter staff ID: ");
    int id = int.parse(stdin.readLineSync()!);
    var staff = hospital.getAllStaff().firstWhere((s) => s.id == id,
        orElse: () => throw Exception("Staff not found"));

    stdout.write("Enter department name: ");
    String deptName = stdin.readLineSync()!;
    var department = hospital.findDepartmentByName(deptName);
    if (department != null) {
      hospital.addStaffToDepartment(staff, department);
    }
  }

  void removeStaff() {
    stdout.write("Enter staff ID to remove: ");
    int id = int.parse(stdin.readLineSync()!);
    for (var d in hospital.departments) {
      var toRemove = d.staffMembers.where((s) => s.id == id).toList();
      if (toRemove.isNotEmpty) {
        d.removeStaff(toRemove.first);
        print(" Staff removed.");
        return;
      }
    }
    print(" Staff not found.");
  }
}
