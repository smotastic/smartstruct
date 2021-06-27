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
