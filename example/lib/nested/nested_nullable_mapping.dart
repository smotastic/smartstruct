

import 'package:smartstruct/smartstruct.dart';
part 'nested_nullable_mapping.mapper.g.dart';

class NullableNestedSource {

  final NestedSubSource? nested;

  NullableNestedSource(this.nested);
}

class NestedSource {
  NestedSubSource nested;

  NestedSource(this.nested);
}

class NestedSubSource {
}


class NullableNestedTarget {

  final NestedSubTarget? nested;

  NullableNestedTarget(this.nested);
}

class NestedSubTarget {
}

@Mapper()
abstract class NullableNestedMapper {
  // The type of "NullableNestedTarget.nested" is nullable and the return 
  // of the nested mapping "fromSubSource" is NestedSubTarget which is 
  // not nullable. In this case the nested mapping is matched.
  NullableNestedTarget fromSource(NestedSource source);

  // The type of "NullableNestedSource.nested" is nullable, but the input 
  // type of the nested mapping "fromSource" is not nullable. The 
  // type of "NullableNestedTarget.nested" is also nullable. In this case
  // the nested mapping is also matched, but a little more work to do. We need to
  // check if the "source.nested" is null and determine whether apply the nested
  // mapping or only return the "null" directly.
  NullableNestedTarget fromNullableSource(NullableNestedSource source);

  NestedSubTarget fromSubSource(NestedSubSource source);
}
