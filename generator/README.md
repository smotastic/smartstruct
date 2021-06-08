# Smartstruct - Dart bean mappings - the easy nullsafe way!

Code generator for generating type-safe mappers, inspired by https://mapstruct.org/

- [Installation](#installation)
- [Setup](#setup)
- [Examples](#examples)

# Installation

Add smartstruct as a dev dependency.

```yaml
dev_dependencies:
  smartstruct:
```

Run the generator

```console
dart run build_runner build
flutter packages pub run build_runner build
// or watch
flutter packages pub run build_runner watch
```

# Setup

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
    Dog(this.breed, this.age, this.name);
}
```

To generate a mapper for these two beans, you need to create a mapper interface.

```dart
// dog.mapper.dart
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
}
class DogModel {
    final String dogName;
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

## Injectable

The Mapper can be made a lazy injectable singleton, by setting the argument _useInjection_ to true, in the Mapper Interface.
In this case you also need to add the injectable dependency, as described here. https://pub.dev/packages/injectable

```dart
@Mapper(useInjectable = true)
abstract class DogMapper {
    Dog fromModel(DogModel model);
}
```

```dart
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
