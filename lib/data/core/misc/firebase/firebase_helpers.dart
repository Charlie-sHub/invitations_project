import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/data/core/models/user_dto.dart';
import 'package:invitations_project/domain/core/entities/user.dart' as entity;
import 'package:invitations_project/domain/core/failures/error.dart';
import 'package:invitations_project/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference<InvitationDto>> invitationDocRef(String id) async =>
      invitationCollection.doc(
        id,
      );

  Future<InvitationDto?> invitationDto(String id) async {
    final reference = invitationCollection.doc(id);
    final snapshot = await reference.get();
    return snapshot.data();
  }

  Future<DocumentReference<UserDto>> currentUserRef() async {
    final firebaseAuthInstance = getIt<FirebaseAuth>();
    final firebaseUser = firebaseAuthInstance.currentUser;
    if (firebaseUser != null) {
      final documentReference = userCollection.doc(firebaseUser.uid);
      return documentReference;
    } else {
      throw UnAuthenticatedError();
    }
  }

  Future<UserDto> currentUserDto() async {
    final documentReference = await currentUserRef();
    final userDocument = await documentReference.get();
    final userDto = userDocument.data()!;
    return userDto;
  }

  Future<entity.User> currentUser() async {
    final userDto = await currentUserDto();
    return userDto.toDomain();
  }

  CollectionReference<UserDto> get userCollection =>
      collection('users').withConverter<UserDto>(
        fromFirestore: (snapshots, _) => UserDto.fromJson(
          snapshots.data()!,
        ),
        toFirestore: (userDto, _) => userDto.toJson(),
      );

  Future<bool> userExistsInCollection(String email) async {
    final query = await userCollection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();
    return query.docs.isNotEmpty;
  }

  CollectionReference<InvitationDto> get invitationCollection =>
      collection('invitations').withConverter<InvitationDto>(
        fromFirestore: (snapshots, _) => InvitationDto.fromJson(
          snapshots.data()!,
        ),
        toFirestore: (invitationDto, _) => invitationDto.toJson(),
      );
}
