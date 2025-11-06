import 'department.dart';
import 'schedule.dart';
import 'staff.dart';

class Hospital {
  String name;
  String address;
  List<Department> departments = [];
  List<Schedule> allSchedules = [];
  List<Staff> allStaff = [];

  Hospital({
    required this.name,
    required this.address,
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

  void addStaff(Staff staff) {
    allStaff.add(staff);
    print(" Staff ${staff.name} added to hospital record.");
  }

    void removeStaff(Staff staff) {
    allStaff.remove(staff);
    for (var dept in departments) {
      dept.removeStaff(staff);
    }
    print(" Staff ${staff.name} removed from hospital.");
  }

  void addStaffToDepartment(Staff staff, Department department) {
    // Remove from old department if exists
    if (staff.department != null) {
      staff.department!.removeStaff(staff);
    }
    // Add to new department
    department.addStaff(staff);
    staff.department = department;
    print('${staff.name} added to ${department.name} department.');
  }

  void assignShiftToStaff(Staff staff, Schedule schedule) {
    staff.assignSchedule(schedule);
    print('Assigned ${schedule.shift} shift to ${staff.name}.');
  }

 List<Staff> getAllStaff() {
  return allStaff;
}

Staff? findStaffById(String id) {
  for (var staff in allStaff) {
    if (staff.id == id) {
      return staff;
    }
  }
  return null; 
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
