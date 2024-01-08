import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:annotations/annotations.dart';
import 'package:generator/src/model_visitor.dart';

class JsonGenerator extends GeneratorForAnnotation<JSONGenAnnotation> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final buffer = StringBuffer();
    String className = '${visitor.className}Gen';
    buffer.writeln('class $className {');
    // FIELDS
    createFields(visitor, buffer);

    // CONSTRUCTOR
    createConstructor(className, visitor, buffer);

    // TO MAP
    createToMap(visitor, buffer);

    // FROM MAP
    createFromMap(className, visitor, buffer);

    // COPYWITH
    createCopyWith(className, visitor, buffer);
    buffer.writeln('}');
    return buffer.toString();
  }

  void createFields(ModelVisitor visitor, StringBuffer buffer) {
    for (MapEntry field in visitor.fields.entries) {
      buffer.writeln('final ${field.value} ${field.key};');
    }
  }

  void createConstructor(
      String className, ModelVisitor visitor, StringBuffer buffer) {
    buffer.writeln('const $className({');
    for (MapEntry field in visitor.fields.entries) {
      buffer.writeln('required this.${field.key},');
    }
    buffer.writeln('});');
  }

  void createToMap(ModelVisitor visitor, StringBuffer buffer) {
    buffer.writeln('Map<String, dynamic> toMap(){');
    buffer.writeln('return {');
    for (MapEntry field in visitor.fields.entries) {
      buffer.writeln("'${field.key}': ${field.key},");
    }
    buffer.writeln('};');
    buffer.writeln('}');
  }

  void createFromMap(
      String className, ModelVisitor visitor, StringBuffer buffer) {
    buffer.writeln('factory $className.fromMap(Map<String, dynamic>){');
    buffer.writeln('return $className(');
    for (MapEntry field in visitor.fields.entries) {
      if (field.value == 'String') {
        buffer.writeln(
          "${field.key}: map['${field.key}'] ?? '' ",
        );
      } else if (field.value == 'int') {
        buffer.writeln("${field.key}: map['${field.key}']?.toInt()");
      } else if (field.value == 'double') {
        buffer.writeln("${field.key}: map['${field.key}']?.toDouble()");
      } else {
        buffer.writeln(
          "${field.key}: map['${field.key}']",
        );
      }
    }
    buffer.writeln(');');
    buffer.writeln('}');
  }

  void createCopyWith(
      String className, ModelVisitor visitor, StringBuffer buffer) {
    buffer.writeln('$className copyWith({');
    for (MapEntry field in visitor.fields.entries) {
      buffer.writeln("${field.value}? ${field.key},");
    }
    buffer.writeln('}) {');
    buffer.writeln('return $className(');
    for (MapEntry field in visitor.fields.entries) {
      buffer.writeln(
        "${field.key}: ${field.key} ?? this.${field.key}",
      );
    }
    buffer.writeln(');');
    buffer.writeln('}');
  }
}
