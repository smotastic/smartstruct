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
