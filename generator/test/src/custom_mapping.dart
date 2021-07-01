part of 'mapper_test_input.dart';

class CustomSource {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String avatar;

  CustomSource(
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatar,
  );
}

class CustomTarget {
  final String fullName;
  final DateTime birthDate;
  final String avatar;

  CustomTarget(
    this.fullName,
    this.birthDate,
    this.avatar,
  );
}

// To have type safety you need extend CustomMapping generic class with specific types.
class DateTimeFromSourceMapper extends CustomMapping<DateTime, CustomSource> {
  const DateTimeFromSourceMapper(
      {required String targetField, required DateTime Function(CustomSource) f})
      : super(targetField: targetField, f: f);
}

// It is type safety way. It must be top level function.
DateTime mapBirthDate(CustomSource input) => DateTime.parse(input.birthDate);

// This is not type safe way, but you don't need to override CustomMapping. It must be top level function.
dynamic mapFullName(dynamic input) {
  final castedInput = input as CustomSource;
  return '${castedInput.firstName} ${castedInput.lastName}';
}

@Mapper()
@ShouldGenerate(r'''
class CustomMapperImpl extends CustomMapper {
  @override
  CustomTarget fromSource(CustomSource source) {
    final customtarget =
        CustomTarget(mapFullName(source), mapBirthDate(source), source.avatar);
    return customtarget;
  }
}
''')
abstract class CustomMapper {
  @DateTimeFromSourceMapper(targetField: 'birthDate', f: mapBirthDate)
  @CustomMapping(targetField: 'fullName', f: mapFullName)
  CustomTarget fromSource(CustomSource source);
}
