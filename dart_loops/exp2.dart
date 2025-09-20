import 'dart:io';

void main() {
  // Input from user
  stdout.write("Enter a number: ");
  int? n = int.parse(stdin.readLineSync()!);

  // Output with loop
  print("Multiplication Table of $n:");
  for (int i = 1; i <= 10; i++) {
    print("$n x $i = ${n * i}");
  }
}