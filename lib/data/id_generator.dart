class IdGenerator {
  static int _doctorCount = 0;
  static int _nurseCount = 0;
  static int _adminCount = 0;

  static String generateDoctorId() {
    _doctorCount++;
    return 'DT${_doctorCount.toString().padLeft(4, '0')}';
  }

  static String generateNurseId() {
    _nurseCount++;
    return 'NS${_nurseCount.toString().padLeft(4, '0')}';
  }

  static String generateAdminId() {
    _adminCount++;
    return 'AD${_adminCount.toString().padLeft(4, '0')}';
  }
    static void setInitialCounters({int doctor = 0, int nurse = 0, int admin = 0}) {
    _doctorCount = doctor;
    _nurseCount = nurse;
    _adminCount = admin;
  }
}
