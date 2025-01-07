String generateId({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort((a, b) => a.compareTo(b));
  String chatId = uids.fold('', (id, uid) => '$id$uid');
  return chatId;
}