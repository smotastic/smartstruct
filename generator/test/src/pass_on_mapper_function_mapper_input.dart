part of 'mapper_test_input.dart';

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
@ShouldGenerate('''
class PassOnMapperFunctionMapperImpl extends PassOnMapperFunctionMapper {
  PassOnMapperFunctionMapperImpl() : super();

  @override
  ComplexFunctionTarget fromSource(ComplexFunctionSource source) {
    final complexfunctiontarget = ComplexFunctionTarget(mapComplexSubSource(
      source,
      mapper: this,
    ));
    return complexfunctiontarget;
  }

  @override
  FunctionSubTarget fromSubSource(FunctionSubSource source) {
    final functionsubtarget = FunctionSubTarget();
    return functionsubtarget;
  }
}
''')
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
