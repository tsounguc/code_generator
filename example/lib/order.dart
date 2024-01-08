import 'package:annotations/annotations.dart';

part 'order.g.dart';

@jsonGen
class Order {
  String name;
  String lastName;
  bool isAdult;
  int age;
}
