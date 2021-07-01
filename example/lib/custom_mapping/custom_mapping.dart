import 'package:smartstruct/smartstruct.dart';

part 'custom_mapping.mapper.g.dart';

class Source {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String avatar;

  Source(
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatar,
  );
}

class Target {
  final String fullName;
  final DateTime birthDate;
  final String avatar;

  Target(
    this.fullName,
    this.birthDate,
    this.avatar,
  );
}

// To have type safety you need extend CustomMapping generic class with specific types.
class DateTimeFromSourceMapper extends CustomMapping<DateTime, Source> {
  const DateTimeFromSourceMapper(
      {required String targetField, required DateTime Function(Source) f})
      : super(targetField: targetField, f: f);
}

// It is type safety way. It must be top level function.
DateTime mapBirthDate(Source input) => DateTime.parse(input.birthDate);

// This is not type safe way, but you don't need to override CustomMapping. It must be top level function.
dynamic mapFullName(dynamic input) {
  final castedInput = input as Source;
  return '${castedInput.firstName} ${castedInput.lastName}';
}

@Mapper()
abstract class CustomMapper {
  @DateTimeFromSourceMapper(targetField: "birthDate", f: mapBirthDate)
  @CustomMapping(targetField: "fullName", f: mapFullName)
  Target fromSource(Source source);
}
