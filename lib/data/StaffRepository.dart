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
    if (content.trim().isEmpty) return [];

    final data = jsonDecode(content);
    var staffJson = data['staff'] as List;

    return staffJson.map((s) {
      String type = s['type'];

      // Load schedule if exists
      Schedule? schedule;
      if (s.containsKey('schedule') && s['schedule'] != null) {
        schedule = Schedule(
          weekNumber: s['schedule']['weekNumber'],
          shift: _parseEnumValue<Shift>(
            Shift.values,
            s['schedule']['shift'],
          ),
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
            salary: (s['salary'] is String)
                ? double.tryParse(s['salary']) ?? 0
                : s['salary'].toDouble(),
            startDate: DateTime.parse(s['startDate']),
            specialization: _parseEnumValue<DoctorSpecialization>(
              DoctorSpecialization.values,
              s['specialization'],
            ),
            yearsOfExperience: (s['yearsOfExperience'] is String)
                ? int.tryParse(s['yearsOfExperience']) ?? 0
                : s['yearsOfExperience'],
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
            salary: (s['salary'] is String)
                ? double.tryParse(s['salary']) ?? 0
                : s['salary'].toDouble(),
            startDate: DateTime.parse(s['startDate']),
            level: _parseEnumValue<NurseLevel>(
              NurseLevel.values,
              s['level'],
            ),
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
            salary: (s['salary'] is String)
                ? double.tryParse(s['salary']) ?? 0
                : s['salary'].toDouble(),
            startDate: DateTime.parse(s['startDate']),
            position: _parseEnumValue<AdminPosition>(
              AdminPosition.values,
              s['position'],
            ),
          );
          admin.schedule = schedule;
          return admin;

        default:
          throw Exception("Unknown staff type: $type");
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
          'shift': s.schedule!.shift.name,
        };
      }

      if (s is Doctor) {
        base['type'] = 'Doctor';
        base['specialization'] = s.specialization.name;
        base['yearsOfExperience'] = s.yearsOfExperience;
      } else if (s is Nurse) {
        base['type'] = 'Nurse';
        base['level'] = s.level.name;
      } else if (s is AdministrativeStaff) {
        base['type'] = 'Admin';
        base['position'] = s.position.name;
      }

      return base;
    }).toList();

    var data = {'staff': staffJson};
    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(data));
  }

  // ============ HELPER ==============
  T _parseEnumValue<T>(List<T> values, dynamic input) {
    if (input is int && input >= 0 && input < values.length) {
      return values[input];
    } else if (input is String) {
      try {
        return values.firstWhere(
          (v) => v.toString().split('.').last.toLowerCase() ==
              input.toLowerCase(),
        );
      } catch (_) {
        return values.first; // fallback to first value
      }
    } else {
      return values.first;
    }
  }
}
