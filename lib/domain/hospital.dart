import 'department.dart';
import 'schedule.dart';
import 'staff.dart';

class Hospital {
  String name;
  String address;
  List<Department> departments = [];
  List<Schedule> allSchedules = [];

  Hospital({
    required this.name,
    required this.address,
    // required this.departments,
  });

  void addDepartment(Department department) {
    departments.add(department);
    print('Department "${department.name}" added to hospital.');
  }

  Department? findDepartmentByName(String deptName) {
    try {
      return departments.firstWhere(
        (d) => d.name.toLowerCase() == deptName.toLowerCase(),
      );
    } catch (e) {
      print('Department "$deptName" not found.');
      return null;
    }
  }

  void addStaffToDepartment(Staff staff, Department department) {
    department.addStaff(staff);
    staff.department = department;
    print('${staff.name} added to ${department.name} department.');
  }

  void assignShiftToStaff(Staff staff, Schedule schedule) {
    staff.assignSchedule(schedule);
    print('Assigned ${schedule.shift} shift to ${staff.name}.');
  }

  List<Staff> getAllStaff() {
    return departments.expand((d) => d.staffMembers).toList();
  }

  List<Staff> getStaffByRole(String role) {
    return getAllStaff()
        .where(
            (s) => s.runtimeType.toString().toLowerCase() == role.toLowerCase())
        .toList();
  }

  Schedule? getStaffSchedule(Staff staff) {
    return staff.schedule;
  }
}
