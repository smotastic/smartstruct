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
