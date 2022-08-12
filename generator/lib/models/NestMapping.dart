
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

class NestMapping {

  final MethodElement method;
  final VariableElement input;
  late final bool returnNullable;

  late final bool methodReturnNullable;
  late final bool inputNullable;
  late final bool methodParamterNullable;

  NestMapping(this.method, this.input) {
    methodReturnNullable = method.returnType.nullabilitySuffix == NullabilitySuffix.question;
    inputNullable = input.type.nullabilitySuffix == NullabilitySuffix.question;
    methodParamterNullable = method.parameters.first.type.nullabilitySuffix == NullabilitySuffix.question;

    returnNullable = 
      (inputNullable && !methodParamterNullable) ||     // 'a == null ? null : call(a)'. So the output is nullable.
      (inputNullable && methodReturnNullable);          // if input is not null, the method return is not
  }

}