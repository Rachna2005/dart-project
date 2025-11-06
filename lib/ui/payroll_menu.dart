import 'dart:io';
import '../domain/hospital.dart';

class PayrollMenu {
  Hospital hospital;
  PayrollMenu(this.hospital);

 void payrollMenu() {
    while (true) {
      print("\n Payroll & Reports");
      print("==========================");
      print("1. Show salary for each staff");
      print("2. Show total salary by department");
      print("3. Show top 3 highest paid staff");
      print("0. Back");
      stdout.write(" Choose: ");
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
          print(" Invalid choice!");
      }
    }
  }
}