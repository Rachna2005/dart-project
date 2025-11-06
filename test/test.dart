import 'package:test/test.dart';
import '../lib/domain/doctor.dart';
import '../lib/domain/nurse.dart';
import '../lib/domain/administrative_staff.dart';
import '../lib/domain/department.dart';
import '../lib/domain/schedule.dart';
import '../lib/domain/hospital.dart';
import '../lib/data/id_generator.dart';

void main() {
  Hospital hospital =
      Hospital(name: 'sunshine Hospital', address: 'phnom penh');
  Department cardiology = Department(id: 1, name: 'Cardiology');
  Doctor doctor = Doctor(
    id: IdGenerator.generateDoctorId(),
    name: 'Dr. John',
    gender: 'Male',
    dateOfBirth: DateTime(1980, 5, 10),
    startDate: DateTime(2010, 1, 1),
    contactNumber: '0123456789',
    email: 'john@hospital.com',
    specialization: DoctorSpecialization.Cardiology,
    yearsOfExperience: 10,
    salary: 5000,
  );
  Nurse nurse = Nurse(
    id: IdGenerator.generateNurseId(),
    name: 'Nurse Mary',
    gender: 'Female',
    dateOfBirth: DateTime(1990, 3, 12),
    startDate: DateTime(2015, 1, 1),
    contactNumber: '0987654321',
    email: 'mary@hospital.com',
    level: NurseLevel.Junior,
    salary: 3000,
  );
  AdministrativeStaff admin = AdministrativeStaff(
    id: IdGenerator.generateAdminId(),
    name: 'Admin Sara',
    gender: 'Female',
    dateOfBirth: DateTime(1985, 6, 20),
    startDate: DateTime(2012, 5, 1),
    contactNumber: '0112233445',
    email: 'sara@hospital.com',
    position: AdminPosition.Receptionist,
    salary: 4000,
  );
  Schedule morningShift = Schedule(
    weekNumber: 1,
    shift: Shift.Morning,
    daysOff: ['Saturday', 'Sunday'],
  );

  test('Add staff to hospital', () {
    hospital.addStaff(doctor);
    hospital.addStaff(nurse);
    hospital.addStaff(admin);
    expect(hospital.allStaff.length, equals(3));
    expect(hospital.allStaff.contains(doctor), true);
  });

  test('Find department by name', () {
    hospital.addDepartment(cardiology);
    Department neurology = Department(id: 2, name: 'Neurology');
    hospital.addDepartment(neurology);
    expect(hospital.findDepartmentByName('Cardiology'), equals(cardiology));
    expect(hospital.findDepartmentByName('Neurology'), equals(neurology));
  });

  test('Assign staff to department', () {
    cardiology.addStaff(doctor);
    expect(doctor.department, equals(cardiology));
    expect(cardiology.staffMembers.contains(doctor), true);
  });

  test('Assign schedule to staff', () {
    doctor.assignSchedule(morningShift);
    expect(doctor.schedule, equals(morningShift));
  });

  test('Calculate monthly salary', () {
    expect(doctor.calculateMonthlySalary(), equals(7000));
    expect(nurse.calculateMonthlySalary(), equals(3000));
    expect(admin.calculateMonthlySalary(), equals(1500));
  });

  test('Test ID generation for multiple staff', () {
    IdGenerator.setInitialCounters(doctor: 2, nurse: 1, admin: 1);

    String newDoctorId = IdGenerator.generateDoctorId();
    String newNurseId = IdGenerator.generateNurseId();
    String newAdminId = IdGenerator.generateAdminId();
    expect(newDoctorId, equals('DT0003'));
    expect(newNurseId, equals('NS0002'));
    expect(newAdminId, equals('AD0002'));
  });

  test('Rotate nurse shift', () {
    nurse.assignSchedule(morningShift);
    expect(nurse.schedule?.shift, equals(Shift.Morning));
    nurse.schedule?.rotateShift();
    expect(nurse.schedule?.shift, equals(Shift.Evening));
  });

  test('Check staff availability', () {
    nurse.assignSchedule(morningShift);
    expect(nurse.isAvailable('Wednesday'), true);
    expect(nurse.isAvailable('Sunday'), false);
  });
}
