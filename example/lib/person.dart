import 'package:annotations/annotations.dart';
part 'person.g.dart';

@jsonGen
class Person {
  String name;
  String lastName;
  bool isAdult;
  int age;
}
