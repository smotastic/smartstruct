import 'package:smartstruct/annotations.dart';
import 'package:smartstruct_example/user_model.dart';
import 'package:smartstruct_example/user.dart';

part 'user_mapper.g.dart';

@Mapper()
abstract class UserMapper {
  User fromModel(UserModel model);
}
