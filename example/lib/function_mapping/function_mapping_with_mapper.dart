import 'package:smartstruct/smartstruct.dart';
part 'function_mapping_with_mapper.mapper.g.dart';

class FunctionSubSource {
}

class FunctionSubTarget {
}

class ComplexFunctionSubTargetHolder {

  FunctionSubTarget? _data;

  setData(FunctionSubTarget data) {
    _data = data;
  }
}

class ComplexFunctionSource {
  FunctionSubSource subSource;

  ComplexFunctionSource(this.subSource);
}

class ComplexFunctionTarget {
  ComplexFunctionSubTargetHolder holder;

  ComplexFunctionTarget(this.holder);
}

@Mapper()
abstract class PassOnMapperFunctionMapper {
  @Mapping(target: "holder", source: mapComplexSubSource)
  ComplexFunctionTarget fromSource(ComplexFunctionSource source);

  FunctionSubTarget fromSubSource(FunctionSubSource source);
}

ComplexFunctionSubTargetHolder mapComplexSubSource(ComplexFunctionSource source, {required PassOnMapperFunctionMapper mapper})  {
  final subTarget = mapper.fromSubSource(source.subSource);
  final holder = ComplexFunctionSubTargetHolder();
  holder.setData(subTarget);
  return holder;
}
