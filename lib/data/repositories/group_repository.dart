import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/group.dart';

class GroupRepository {
  final FirebaseFirestore firestore;

  GroupRepository({required this.firestore});

  Future<void> createGroupChat(Group group) async {
    var groupId = firestore.collection('group').doc().id;
    group.groupId = groupId;
    await firestore.collection('group').doc(groupId).set(group.toMap());
  }

  Future<Group> loadSingleGroup(String groupId) async {
    var ref = await firestore.collection('group').doc(groupId).get();
    return Group.fromJson(ref.data()!);
  }

  Stream<Group> loadStreamGroup(String uid) async* {
    var profile = firestore.collection('group').doc(uid).snapshots();
    yield* profile.map((event) => Group.fromJson(event.data()!));
  }

  Future<void> updateGroupMember(String groupId, List<String> members) async {
    await firestore.collection('group').doc(groupId).update({
      'members': members,
    });
  }

  Future<void> updateImageGroup(String groupId, String url) async {
    firestore.collection('group').doc(groupId).update({'photo': url});
  }

  Future<void> updateGroupName(String groupId, String name) async {
    firestore.collection('group').doc(groupId).update({'name': name});
  }
}
