import '../../../../core/error/exceptions.dart';

abstract class HasherDataSource {
  /// Throws HashingException
  Future<String> hash(String pass);
}

/// flutter_bcrypt implements this
typedef BcryptSalter = Future<String> Function();

/// flutter_bcrypt implements this
typedef BcryptHasher = Future<String> Function({required String password, required String salt});

class HasherDataSourceImpl implements HasherDataSource {
  final BcryptSalter _salter;
  final BcryptHasher _hasher;
  const HasherDataSourceImpl(this._salter, this._hasher);

  @override
  Future<String> hash(String pass) async {
    try {
      return _hasher(
        password: pass,
        salt: await _salter(),
      );
    } catch (e) {
      throw HashingException();
    }
  }
}
