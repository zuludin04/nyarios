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
}
