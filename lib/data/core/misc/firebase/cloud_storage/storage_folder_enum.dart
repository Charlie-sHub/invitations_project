enum StorageFolder {
  users,
  invitations,
}

extension ParseToString on StorageFolder {
  String value() => toString().split('.').last;
}
