# Smartstruct - Dart bean mappings - the easy nullsafe way!

Code generator for generating type-safe mappers in dart, inspired by https://mapstruct.org/

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Roadmap](#roadmap)

# Overview

- Add smartstruct as a dependency, and smartstruct_generator as a dev_dependency
- Create a Mapper class
- Annotate the class with @mapper
- Run the build_runner
- Use the generated Mapper!

# Installation

Add smartstruct as a dependency, and the generator as a dev_dependency.

https://pub.dev/packages/smartstruct

```yaml
dependencies:
  smartstruct: [version]

dev_dependencies:
  smartstruct_generator: [version]
  # add build runner if not already added
  build_runner:
```

Run the generator

```console
dart run build_runner build
flutter packages pub run build_runner build
// or watch
flutter packages pub run build_runner watch
```

# Usage

Create your beans.

```dart
class Dog {
    final String breed;
    final int age;
    final String name;
    Dog(this.breed, this.age, this.name);
}
```

```dart
class DogModel {
    final String breed;
    final int age;
    final String name;
    DogModel(this.breed, this.age, this.name);
}
```

To generate a mapper for these two beans, you need to create a mapper interface.

```dart
// dogmapper.dart
part 'dogmapper.mapper.g.dart';

@Mapper()
abstract class DogMapper {
    Dog fromModel(DogModel model);
}
```

Once you ran the generator, next to your _dog.mapper.dart_ a _dog.mapper.g.dart_ will be generated.

```
dart run build_runner build
```

```dart
// dogmapper.mapper.g.dart
class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.breed, model.age, model.name);
        return dog;
    }
}
```

The Mapper supports positional arguments, named arguments and property access via implicit and explicit setters.

## Case sensitivity

By default mapper generator works in case insensitivity manner. 

```dart
class Source {
  final String userName;

  Source(this.userName);
}

class Target {
  final String username;

  Target({required this.username});
}

@Mapper()
abstract class ExampleMapper {
  Target fromSource(Source source);
}
```
As you can see, classes above got different field's names (case) for username. Because mappers are case insensitive by default, those classes are correctly mapped. 
```dart

class ExampleMapperImpl extends ExampleMapper {
  @override
  Target fromSource(Source source) {
    final target = Target(username: source.userName);
    return target;
  }
}
```
To create case sensitive mapper, you can add param caseSensitiveFields to @Mapper annotation. Case sensitive mapper is checking field's names in case sensitive manner.
```dart

@Mapper(caseSensitiveFields: true)
abstract class ExampleMapper {
  Target fromSource(Source source);
}
```


## Explicit Field Mapping

If some fields do not match each other, you can add a Mapping Annotation on the method level, to change the behaviour of certain mappings.

```dart
class Dog {
    final String name;
    Dog(this.name);
}
class DogModel {
    final String dogName;
    DogModel(this.dogName);
}
```

```dart
@Mapper()
class DogMapper {
    @Mapping(source: 'dogName', target: 'name')
    Dog fromModel(DogModel model);
}
```

In this case, the field _dogName_ of _DogModel_ will be mapped to the field _name_ of the resulting _Dog_

```dart
class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.dogName);
        return dog;
    }
}
```

### Function Mapping
The source attribute can also be a Function. This Function will then be called with the Source Parameter of the mapper method as a parameter.
```dart
class Dog {
    final String name;
    final String breed;
    Dog(this.name, this.breed);
}
class DogModel {
    final String name;
    DogModel(this.name);
}
```

```dart
@Mapper()
class DogMapper {
    static String randomBreed(DogModel model) => 'some random breed';

    @Mapping(source: randomBreed, target: 'breed')
    Dog fromModel(DogModel model);
}
```

Will generate the following Mapper.
```dart
class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.dogName, DogMapper.randomBreed(model));
        return dog;
    }
}
```
### Ignore Fields
Fields can be ignored, by specififying the `ignore` attribute on the Mapping `Annotation``

```dart
class Dog {
    final String name;
    String? breed;
    Dog(this.name);
}
class DogModel {
    final String name;
    final String breed;
    DogModel(this.name, this.breed);
}
```

```dart
@Mapper()
class DogMapper {
    @Mapping(target: 'breed', ignore: true)
    Dog fromModel(DogModel model);
}
```

Will generate the following Mapper.
```dart
class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.name);
        return dog;
    }
}
```

## Nested Bean Mapping

Nested beans can be mapped, by defining an additional mapper method for the nested bean.

```dart
// nestedmapper.dart
class NestedTarget {
  final SubNestedTarget subNested;
  NestedTarget(this.subNested);
}
class SubNestedTarget {
  final String myProperty;
  SubNestedTarget(this.myProperty);
}

class NestedSource {
  final SubNestedSource subNested;
  NestedSource(this.subNested);
}

class SubNestedSource {
  final String myProperty;
  SubNestedSource(this.myProperty);
}

@Mapper()
abstract class NestedMapper {
  NestedTarget fromModel(NestedSource model);

  SubNestedTarget fromSubClassModel(SubNestedSource model);
}
```

Will generate the mapper

```dart
// nestedmapper.mapper.g.dart
class NestedMapperImpl extends NestedMapper {
  @override
  NestedTarget fromModel(NestedSource model) {
    final nestedtarget = NestedTarget(fromSubClassModel(model.subNested));
    return nestedtarget;
  }

  @override
  SubNestedTarget fromSubClassModel(SubNestedSource model) {
    final subnestedtarget = SubNestedTarget(model.myProperty);
    return subnestedtarget;
  }
}

```

Alternatively you can directly define the nested mapping in the source attribute.

```dart
class User {
  final String username;
  final String zipcode;
  final String street;

  User(this.username, this.zipcode, this.street);
}

class UserResponse {
  final String username;
  final AddressResponse address;

  UserResponse(this.username, this.address);
}

class AddressResponse {
  final String zipcode;
  final StreetResponse street;

  AddressResponse(this.zipcode, this.street);
}

class StreetResponse {
  final num streetNumber;
  final String streetName;

  StreetResponse(this.streetNumber, this.streetName);
}
```
With this, you can define the mappings directly in the `Mapping` Annotation

```dart
@Mapper()
abstract class UserMapper {
  @Mapping(target: 'zipcode', source: 'response.address.zipcode')
  @Mapping(target: 'street', source: 'response.address.street.streetName')
  User fromResponse(UserResponse response);
}
```

Would generate the following mapper.
```dart
class UserMapperImpl extends UserMapper {
  UserMapperImpl() : super();

  @override
  User fromResponse(UserResponse response) {
    final user = User(response.username, response.address.zipcode,
        response.address.street.streetName);
    return user;
  }
}
```

## List Support
Lists will be mapped as new instances of a list, with help of the map method.
```dart
class Source {
  final List<int> intList;
  final List<SourceEntry> entryList;

  Source(this.intList, this.entryList);
}

class SourceEntry {
  final String prop;

  SourceEntry(this.prop);
}

class Target {
  final List<int> intList;
  final List<TargetEntry> entryList;

  Target(this.intList, this.entryList);
}

class TargetEntry {
  final String prop;

  TargetEntry(this.prop);
}

@Mapper()
abstract class ListMapper {
  Target fromSource(Source source);
  TargetEntry fromSourceEntry(SourceEntry source);
}
```
Will generate the Mapper

```dart
class ListMapperImpl extends ListMapper {
  @override
  Target fromSource(Source source) {
    final target = Target(
      source.intList.map((e) => e).toList(),
      source.entryList.map(fromSourceEntry).toList());
    return target;
  }

  @override
  TargetEntry fromSourceEntry(SourceEntry source) {
    final targetentry = TargetEntry(source.prop);
    return targetentry;
  }
}
```

## Injectable

The Mapper can be made a lazy injectable singleton, by setting the argument _useInjection_ to true, in the Mapper Interface.
In this case you also need to add the injectable dependency, as described here. https://pub.dev/packages/injectable

Make sure, that in the Mapper File, you import the injectable dependency, before running the build_runner!

```dart
// dogmapper.dart

import 'package:injectable/injectable.dart';

@Mapper(useInjectable = true)
abstract class DogMapper {
    Dog fromModel(DogModel model);
}
```

```dart
// dogmapper.mapper.g.dart
@LazySingleton(as: DogMapper)
class DogMapperImpl extends DogMapper {...}
```

## Freezed
Generally you can use smartstruct with [freezed](https://pub.dev/packages/freezed).

One problem you will have to manually workaround is ignoring the freezed generated `copyWith` method in the generated mapper.
The copyWith field is a normal field in the model / entity, and smartstruct does not have a way of knowing on when to filter it out, and when not.

Imagine having the following freezed models.
```dart
@freezed
class Dog with _$Dog {
  Dog._();
  factory Dog(String name) = _Dog;
}

@freezed
class DogModel with _$DogModel {
  factory DogModel(String name) = _DogModel;
}
```

Freezed will generate a `copyWith` field for your `Dog` and `DogModel`.

When generating the mapper, you explicitly have to ignore this field.
```dart
@Mapper()
abstract class DogMapper {
  @Mapping(target: 'copyWith', ignore: true)
  Dog fromModel(DogModel model);
}
```
Will generate the mapper, using the factory constructor.
```dart
class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromModel(DogModel model) {
    final dog = Dog(model.name);
    return freezedtarget;
  }
}
```

## Static Mapping
Static Methods in a Mapper Class will automatically be mapped with a static pendant in the generated mapper file.


```dart
class Dog {
    final String name;
    Dog(this.name);
}
class DogModel {
    final String name;
    DogModel(this.name);
}
```

```dart
@Mapper()
class DogMapper {
    static Dog fromModel(DogModel model) => _$fromModel(model);
}
```

Will generate a mapper file providing the following static methods.
```dart
Dog _$fromModel(DogModel model) {
  final dog = Dog(model.name);
  return dog;
}
```

## Static Mapping with a proxy
Alternatively you can set ``generateStaticProxy`` to ``true``in the Mapping Annotation, to generate a Mapper Proxy implementation for your static methods.
```dart
class Dog {
    final String name;
    Dog(this.name);
}
class DogModel {
    final String name;
    DogModel(this.name);
}
```

```dart
@Mapper(generateStaticProxy = true)
class DogMapper {
    Dog fromModel(DogModel model);
}
```

Will generate the following mapper.
```dart
class DogMapperImpl extends DogMapper {
  DogMapperImpl() : super();

  @override
  Dog fromModel(DogModel model) {
    final dog = Dog(model.name);
    return dog;
  }
}

class DogMapper$ {
  static final DogMapper mapper = DogMapperImpl();

  static Dog fromModel(DogModel model) =>
      mapper.fromModel(model);
}
```

# Examples

Please refer to the [example](https://github.com/smotastic/smartstruct/tree/master/example) package, for a list of examples and how to use the Mapper Annotation.

You can always run the examples by navigating to the examples package and executing the generator.

```console
$ dart pub get
...
$ dart run build_runner build
```

# Roadmap

Feel free to open a [Pull Request](https://github.com/smotastic/smartstruct/pulls), if you'd like to contribute.

Or just open an issue, and i do my level best to deliver.
