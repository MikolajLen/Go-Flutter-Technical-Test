abstract class LoginPersister {
  Future<void> persistUserId(int id);

  Future<int> getUserId();

  Future<void> wipeUserData();
}
