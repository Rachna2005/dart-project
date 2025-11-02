import 'staff.dart';

class Department {
  int id;
  String name;
  List<Staff> staffMembers;

  Department({
    required this.id,
    required this.name,
    required this.staffMembers,
  });

  void addStaff(Staff staff) {
    staffMembers.add(staff);
    staff.department = this;
    print('${staff.name} has been added to $name department.');
  }

  void removeStaff(Staff staff) {
    if (staffMembers.remove(staff)) {
      staff.department = null;
      print('${staff.name} has been removed from $name department.');
    } else {
      print('${staff.name} is not in $name department.');
    }
  }

  //   Staff? findStaffById(int id) {
  //   return staffMembers.firstWhere(
  //     (staff) => staff.id == id,
  //     orElse: () => null,
  //   );
  // }

  void displayDepartmentInfo() {
    print('--- Department: $name ---');
    if (staffMembers.isEmpty) {
      print('No staff members in this department.');
    } else {
      for (var staff in staffMembers) {
        print('- ${staff.name} (${staff.runtimeType})');
      }
    }
  }

  @override
  String toString() {
    return 'Department{id: $id, name: $name, staffMembers: $staffMembers}';
  }
}
