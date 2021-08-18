# v1.2.2
Fixes:
- The generator will now always run after all .g.dart files from other builders have been run, so the mapper can potentially create mappers for other created classes. See Issue [#24](https://github.com/smotastic/smartstruct/issues/24)

# v.1.2.1
- Constructors in the abstract mapper will now also be implemented by the generated mapper class (https://github.com/smotastic/smartstruct/issues/22).
This should fix an issue where you cannot inject dependencies via the constructor in your mapper class.

# v1.2.0
- Fixed the useInjection attribute to properly work now (https://github.com/smotastic/smartstruct/issues/19)
Note that all generated files are suffixed with *.mapper.g.dart* now instead of *.g.dart*
So for migration purposes you'll have to just change the *part 'foomapper.g.dart'* in your mapper files to *part 'foomapper.mapper.g.dart*
```dart
// before
part 'foomapper.g.dart'
// after
part 'foomapper.mapper.g.dart'
```
# v1.1.3
- Added Support for Lists (https://github.com/smotastic/smartstruct/issues/12)

# v1.1.2+1

- Added tests for the generator (https://github.com/smotastic/smartstruct/issues/8)
- Added Example
- Documentation

# v1.1.2

- Hotfix: Change Builder dependency in build.yaml

# v1.1.1

- Hotfix. Forgot to add smartstruct pub dev dependency

# v1.1.0

- Split the code into a generator, and smartstruct library project.
  To migrate from earlier versions, you need to add the _smartstruct_generator_ dependency to your dev_dependencies
  This has the advantage that your final build won't have to include the builder code, but only the mapper annotations

# v1.0.5

- Add support for optional source and target parameters

# v.1.0.4

- Add support for nested bean mapping

# v1.0.3

- README updated

# v1.0.2

- README updates

# v1.0.1

- Added explicit field mapping support via Mapping Annotation

# v1.0.0

- Initial Mapper Annotation published
