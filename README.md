# Smartstruct - Dart bean mappings - the easy nullsafe way!

Code generator for generating type-safe mappers, inspired by https://mapstruct.org/

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)

# Installation

Add smartstruct as a dev dependency.

https://pub.dev/packages/smartstruct

```yaml
dev_dependencies:
  smartstruct: [version]
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
// dog.mapper.dart
part 'dog.mapper.g.dart';

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
// dog.mapper.g.dart
class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.breed, model.age, model.name);
        return dog;
    }
}
```

The Mapper supports positional arguments, named arguments and property access via implicit and explicit setters.

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

## Nested Bean Mapping

Nested beans can be mapped, by defining an additional mapper method for the nested bean.

```dart
// mapper.dart
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
// mapper.g.dart
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

## Injectable

The Mapper can be made a lazy injectable singleton, by setting the argument _useInjection_ to true, in the Mapper Interface.
In this case you also need to add the injectable dependency, as described here. https://pub.dev/packages/injectable

```dart
// dog.mapper.dart
@Mapper(useInjectable = true)
abstract class DogMapper {
    Dog fromModel(DogModel model);
}
```

```dart
// dog.mapper.g.dart
@LazySingleton(as: DogMapper)
class DogMapperImpl extends DogMapper {...}
```

# Examples

Please refer to the [example](https://github.com/smotastic/smartstruct/tree/master/example) package, for a list of examples and how to use the Mapper Annotation.

You can always run the examples by navigating to the examples package and executing the generator.

```console
$ dart pub get
...
$ dart run build_runner build
```
