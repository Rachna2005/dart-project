import 'dart:convert';
import 'dart:io';
import '../domain/department.dart';
import '../domain/staff.dart';

class DepartmentRepository {
  final String filePath;

  DepartmentRepository({required this.filePath});

  /// Read departments from file and link staff by their IDs
  List<Department> readDepartments(List<Staff> staffList) {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    final data = jsonDecode(content) as List;

    List<Department> departments = [];

    for (var d in data) {
      var department = Department(
        id: d['id'],
        name: d['name'],
        staffMembers: [],
      );

      // Assign staff to this department based on stored staff IDs
      if (d.containsKey('staffIds')) {
        for (var staffId in d['staffIds']) {
          try {
            var staff = staffList.firstWhere((s) => s.id == staffId);
            department.addStaff(staff);
          } catch (e) {
            // Staff not found, skip silently
          }
        }
      }

      departments.add(department);
    }

    return departments;
  }

  /// Save departments to file, including staff assignments
  void writeDepartments(List<Department> departments) {
    final file = File(filePath);
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);

    final data = departments.map((d) => {
          'id': d.id,
          'name': d.name,
          'staffIds': d.staffMembers.map((s) => s.id).toList(),
        }).toList();

    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(data));
  }
}
