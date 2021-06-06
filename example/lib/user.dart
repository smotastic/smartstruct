class User {
  final num id;
  String? name;

  String? _lastName;

  String? get lastName => _lastName;

  set lastName(String? lastName) {
    _lastName = lastName;
  }

  final String unknown;
  final bool isActivated;

  User(this.id, this.isActivated, this.unknown, {this.name});
  // User.id(this.id,
  //     {this.isActivated = true, this.unknown = '', this.name = ''});
}
