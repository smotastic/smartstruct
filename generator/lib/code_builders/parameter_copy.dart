import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

Parameter copyParameter(ParameterElement e) {
  if (e.type.element == null) {
    throw InvalidGenerationSourceError(
        '${e.type} is not a valid parameter type',
        element: e,
        todo: 'Add valid parameter type to mapping parameters');
  }

  return Parameter(
    (b) => b
      ..required = e.isRequiredNamed
      ..named = e.isNamed
      ..name = e.name
      ..type = refer(e.type.getDisplayString(withNullability: true))
      ..defaultTo = e.hasDefaultValue ? refer(e.defaultValueCode!).code : null,
  );
}
