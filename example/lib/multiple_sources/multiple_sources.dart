import 'package:smartstruct/smartstruct.dart';

part 'multiple_sources.mapper.g.dart';

class Target {
  final String text1;
  final String text2;
  final String text3;
  final String allText;

  Target(this.text1, this.text2, this.text3, this.allText);
}

class Source {
  final String text1;
  Source(this.text1);
}

class Source2 {
  final String text2;
  Source2(this.text2);
}

class Source3 {
  final String text3;
  Source3(this.text3);
}

@Mapper()
abstract class MultipleSourcesMapper {
  @Mapping(source: allText, target: 'allText')
  Target fromSource(Source source, Source2 source2, Source3 source3);
}

String allText(Source source, Source2 source2, Source3 source3) =>
    source.text1 + source2.text2 + source3.text3;
