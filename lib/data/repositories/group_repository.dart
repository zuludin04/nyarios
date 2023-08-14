import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/group.dart';

class GroupRepository {
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('group');

  Future<void> createGroupChat(Group group) async {
    var groupId = contactReference.doc().id;
    group.groupId = groupId;
    await contactReference.doc(groupId).set(group.toMap());
  }

  Future<Group> loadSingleGroup(String groupId) async {
    var ref =
        await FirebaseFirestore.instance.collection('group').doc(groupId).get();
    return Group.fromJson(ref.data()!);
  }

  Stream<Group> loadStreamGroup(String uid) async* {
    var profile =
        FirebaseFirestore.instance.collection('group').doc(uid).snapshots();
    yield* profile.map((event) => Group.fromJson(event.data()!));
  }
}
