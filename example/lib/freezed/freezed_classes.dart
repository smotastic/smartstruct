import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_classes.freezed.dart';

@freezed
class FreezedTarget with _$FreezedTarget {
  FreezedTarget._();
  factory FreezedTarget(String name, int age) = _FreezedTarget;
}

@freezed
class FreezedSource with _$FreezedSource {
  factory FreezedSource(String name, int age) = _FreezedSource;
}

@freezed
class FreezedNamedTarget with _$FreezedNamedTarget {
  FreezedNamedTarget._();
  factory FreezedNamedTarget({String? name, int? age}) = _FreezedNamedTarget;
}

@freezed
class FreezedNamedSource with _$FreezedNamedSource {
  factory FreezedNamedSource({String? name, int? age}) = _FreezedNamedSource;
}
