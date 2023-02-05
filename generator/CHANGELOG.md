# v1.4.0
* Extending default types to be ignored by static mapping
  (https://github.com/smotastic/smartstruct/issues/74)
* Nullable lists are not being mapped properly. (https://github.com/smotastic/smartstruct/issues/41)
* Update to analyzer 5.0.0 (https://github.com/smotastic/smartstruct/issues/78)


# v1.3.0
* Bump Analyzer to 4.0.0 (Thanks to @luissalgadofreire)

## Bugfixes
* Fix Static Functional Mapping (https://github.com/smotastic/smartstruct/issues/68)

# v1.2.7

## Bugfixes
* Generator does not recognize inherited methods https://github.com/smotastic/smartstruct/issues/56 (Thanks to @skykaka)
* Unable to generate files in different directories https://github.com/smotastic/smartstruct/issues/54 (Thanks to @skykaka)

## Features
Static Mapping (https://github.com/smotastic/smartstruct/issues/53)
Static Mapping with a proxy (https://github.com/smotastic/smartstruct/pull/59) (Thanks to @skykaka)

# v1.2.6
- Nested Mapping directly in the mapping annotation (https://github.com/smotastic/smartstruct/issues/26)
- Better support for freezed (https://github.com/smotastic/smartstruct/issues/29)


# v1.2.5
- Ignore certain fields (https://github.com/smotastic/smartstruct/issues/40)

# v1.2.4+1
- Bugfix: Mapper failing to generate when using interfaces https://github.com/smotastic/smartstruct/issues/35


# v1.2.4
- Support inheritance (https://github.com/smotastic/smartstruct/pull/32)


# v.1.2.3+1
- Updated analyzer dependency to 2.0.0


# v.1.2.3
Features:
- Added the functionality to add custom mapper function to a target (https://github.com/smotastic/smartstruct/pull/28)
- New option caseSensitiveFields to turn on or off case sensitivity then comparing mappable fields (https://github.com/smotastic/smartstruct/pull/18)


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
