library generator;

import 'package:build/build.dart';
import 'package:generator/src/json_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateJsonClass(BuilderOptions options) => SharedPartBuilder(
      [JsonGenerator()],
      'json_generator',
    );
