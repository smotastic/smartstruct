# Simple Mapping

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
import 'package:smartstruct/smartstruct.dart';

// dog.mapper.dart
part 'dog.mapper.g.dart';

@mapper
abstract class DogMapper {
    Dog fromModel(DogModel model);
}
```

# Explicit Field Mapping

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
// dog.mapper.dart
import 'package:smartstruct/smartstruct.dart';

part 'dog.mapper.g.dart';

@Mapper()
class DogMapper {
    @Mapping(source: 'dogName', target: 'name')
    Dog fromModel(DogModel model);
}
```

In this case, the field _dogName_ of _DogModel_ will be mapped to the field _name_ of the resulting _Dog_

```dart
// dog.mapper.g.dart

class DogMapperImpl extends DogMapper {
    @override
    Dog fromModel(DogModel model) {
        Dog dog = Dog(model.dogName);
        return dog;
    }
}
```

# Nested Bean Mapping

Nested beans can be mapped, by defining an additional mapper method for the nested bean.

```dart
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
```

```dart
// nested.mapper.dart
import 'package:smartstruct/smartstruct.dart';

part 'nested.mapper.g.dart';

@Mapper()
abstract class NestedMapper {
  NestedTarget fromModel(NestedSource model);

  SubNestedTarget fromSubClassModel(SubNestedSource model);
}
```

Will generate the mapper

```dart
// nested.mapper.g.dart
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


# List Support
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

# Injectable

The Mapper can be made a lazy injectable singleton, by setting the argument _useInjection_ to true, in the Mapper Interface.
In this case you also need to add the injectable dependency, as described here. https://pub.dev/packages/injectable

```dart
// dog.mapper.dart

import 'package:smartstruct/smartstruct.dart';

part 'dog.mapper.g.dart';

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
