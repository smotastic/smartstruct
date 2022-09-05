
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:smartstruct_generator/code_builders/parameter_copy.dart';

Class generateStaticProxy(ClassElement abstractMapper) {
  return Class(
    (b) => b
      ..name = '${abstractMapper.displayName}\$'
      ..fields.add(Field((f) => 
        f..name = "mapper"
         ..modifier = FieldModifier.final$
         ..type = refer(abstractMapper.thisType.getDisplayString(withNullability: true))
         ..assignment = refer('${abstractMapper.name}Impl()').code
         ..static = true
      ))
      ..methods.addAll(abstractMapper.methods
          .where((method) => method.isAbstract)
          .map((method) =>
              buildStaticMethod(method, abstractMapper))),
  );
}

Method buildStaticMethod(MethodElement method, ClassElement element) {
  final argList = method.parameters.map((e) => copyParameter(e));
  final argNameList = method.parameters.map((e) => refer(e.name));
  return Method((b) => 
    b..static = true
     ..name = method.displayName
     ..requiredParameters.addAll(argList)
     ..body = refer("mapper.${method.displayName}").call(argNameList).code
     ..returns = refer(method.returnType.getDisplayString(withNullability: true))
  );
}