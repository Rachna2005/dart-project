import 'dart:convert';
import 'dart:io';
import '../domain/staff.dart';
import '../domain/doctor.dart';
import '../domain/nurse.dart';
import '../domain/administrative_staff.dart';
import '../domain/schedule.dart';

class StaffRepository {
  final String filePath;

  StaffRepository({required this.filePath});

  // ================= READ STAFF =================
  List<Staff> readStaff() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    final data = jsonDecode(content);
    var staffJson = data['staff'] as List;

    return staffJson.map((s) {
      String type = s['type'];

      // Load schedule if it exists
      Schedule? schedule;
      if (s.containsKey('schedule') && s['schedule'] != null) {
        schedule = Schedule(
          weekNumber: s['schedule']['weekNumber'],
          shift: Shift.values[s['schedule']['shift']],
        );
      }

      switch (type) {
        case 'Doctor':
          var doctor = Doctor(
            id: s['id'],
            name: s['name'],
            gender: s['gender'],
            dateOfBirth: DateTime.parse(s['dateOfBirth']),
            contactNumber: s['contactNumber'],
            email: s['email'],
            salary: s['salary'],
            startDate: DateTime.parse(s['startDate']),
            specialization: s['specialization'],
            yearsOfExperience: s['yearsOfExperience'],
          );
          doctor.schedule = schedule;
          return doctor;

        case 'Nurse':
          var nurse = Nurse(
            id: s['id'],
            name: s['name'],
            gender: s['gender'],
            dateOfBirth: DateTime.parse(s['dateOfBirth']),
            contactNumber: s['contactNumber'],
            email: s['email'],
            salary: s['salary'],
            startDate: DateTime.parse(s['startDate']),
            level: NurseLevel.values[s['level']],
          );
          nurse.schedule = schedule;
          return nurse;

        case 'Admin':
          var admin = AdministrativeStaff(
            id: s['id'],
            name: s['name'],
            gender: s['gender'],
            dateOfBirth: DateTime.parse(s['dateOfBirth']),
            contactNumber: s['contactNumber'],
            email: s['email'],
            salary: s['salary'],
            startDate: DateTime.parse(s['startDate']),
            position: AdminPosition.values[s['position']],
          );
          admin.schedule = schedule;
          return admin;

        default:
          throw Exception("Unknown staff type");
      }
    }).toList();
  }

  // ================= WRITE STAFF =================
  void writeStaff(List<Staff> staffList) {
    final file = File(filePath);
    // Ensure directory exists
  if (!file.parent.existsSync()) {
    file.parent.createSync(recursive: true);
  }
    var staffJson = staffList.map((s) {
      Map<String, dynamic> base = {
        'id': s.id,
        'name': s.name,
        'gender': s.gender,
        'dateOfBirth': s.dateOfBirth.toIso8601String(),
        'contactNumber': s.contactNumber,
        'email': s.email,
        'salary': s.salary,
        'startDate': s.startDate.toIso8601String(),
      };

      // Include schedule if exists
      if (s.schedule != null) {
        base['schedule'] = {
          'weekNumber': s.schedule!.weekNumber,
          'shift': s.schedule!.shift.index,
        };
      }

      if (s is Doctor) {
        base['type'] = 'Doctor';
        base['specialization'] = s.specialization;
        base['yearsOfExperience'] = s.yearsOfExperience;
      } else if (s is Nurse) {
        base['type'] = 'Nurse';
        base['level'] = s.level.index;
      } else if (s is AdministrativeStaff) {
        base['type'] = 'Admin';
        base['position'] = s.position.index;
      }
    
      return base;
    }).toList();

    var data = {'staff': staffJson};
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);

    file.writeAsStringSync(jsonString);
  }
}
