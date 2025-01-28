import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/home/repository/home_repository_interface.dart';
import 'package:logger/logger.dart';

@LazySingleton(
  as: HomeRepositoryInterface,
  env: [Environment.prod],
)
class ProductionHomeRepository implements HomeRepositoryInterface {
  final Logger _logger;
  final FirebaseFirestore _firestore;

  ProductionHomeRepository(
    this._logger,
    this._firestore,
  );

  @override
  Future<Either<Failure, List<Invitation>>> getExampleInvitations() async {
    try {
      final query = await _firestore.invitationCollection
          .where("type", isEqualTo: "example")
          .get();
      final examples = query.docs.map(
        (queryDocumentSnapshot) => queryDocumentSnapshot.data().toDomain(),
      );
      return right(examples.toList());
    } catch (error) {
      return _onError(error);
    }
  }

  Either<Failure, T> _onError<T>(dynamic error) {
    if (error is FirebaseException) {
      _logger.e("FirebaseException: ${error.message}");
      return left(
        Failure.data(
          DataFailure.serverError(
            errorString: "Firebase error: ${error.message}",
          ),
        ),
      );
    } else {
      _logger.e("Unknown Exception: ${error.runtimeType}");
      return left(
        const Failure.data(
          DataFailure.serverError(errorString: "Unknown server error"),
        ),
      );
    }
  }
}
