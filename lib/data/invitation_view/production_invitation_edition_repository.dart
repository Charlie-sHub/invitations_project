import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:invitations_project/domain/invitation_view/repository/invitation_view_repository_interface.dart';
import 'package:logger/logger.dart';

@LazySingleton(
  as: InvitationViewRepositoryInterface,
  env: [Environment.prod],
)
class ProductionInvitationViewRepository
    implements InvitationViewRepositoryInterface {

  ProductionInvitationViewRepository(
    this._logger,
    this._firestore,
  );
  final Logger _logger;
  final FirebaseFirestore _firestore;

  @override
  Future<Either<Failure, Invitation>> loadInvitation(UniqueId id) async {
    try {
      final snapshot =
          await _firestore.invitationCollection.doc(id.getOrCrash()).get();
      if (snapshot.exists) {
        return right(snapshot.data()!.toDomain());
      } else {
        return left(
          const Failure.data(
            DataFailure.notFoundError(),
          ),
        );
      }
    } on Exception catch (error) {
      return _onError(error);
    }
  }

  Either<Failure, T> _onError<T>(dynamic error) {
    if (error is FirebaseException) {
      _logger.e('FirebaseException: ${error.message}');
      return left(
        Failure.data(
          DataFailure.serverError(
            errorString: 'Firebase error: ${error.message}',
          ),
        ),
      );
    } else {
      _logger.e('Unknown Exception: ${error.runtimeType}');
      return left(
        const Failure.data(
          DataFailure.serverError(errorString: 'Unknown server error'),
        ),
      );
    }
  }
}
