import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/failures/data_failure.dart';
import 'package:invitations_project/data/core/misc/firebase/cloud_storage/cloud_storage_service.dart';
import 'package:invitations_project/data/core/misc/firebase/firebase_helpers.dart';
import 'package:invitations_project/data/core/models/invitation_dto.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:logger/logger.dart';

@LazySingleton(
  as: CartRepositoryInterface,
  env: [Environment.prod],
)
class ProductionCartRepository implements CartRepositoryInterface {
  final Logger _logger;
  final FirebaseFirestore _firestore;
  final CloudStorageService _cloudStorage;

  ProductionCartRepository(
    this._logger,
    this._firestore,
    this._cloudStorage,
  );

  @override
  Future<Either<Failure, Unit>> purchase() async {
    try {
      // TODO: Implement purchases
      // Once there's a Stripe business account and the Blaze plan for Firebase
      return right(unit);
    } catch (error) {
      return _onError(error);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteInvitation(UniqueId id) async {
    try {
      final reference = await _firestore.invitationDocRef(id.getOrCrash());
      // TODO: Implement images deletion
      /*
      final snapshot = await reference.get();
      final invitationDto = snapshot.data();
      for (final _imageUrl in invitationDto!.imageURLs) {
        _cloudStorage.deleteImage(_imageUrl);
      }
       */
      reference.delete();
      return right(unit);
    } catch (error) {
      return _onError(error);
    }
  }

  @override
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation) async {
    try {
      // TODO: Add images upload
      /*
      final _imageAssets = invitation.imageAssetsOption.getOrElse(() => []);
      for (final _imageAsset in _imageAssets) {
        final _imageName = _imageAsset.name! + invitation.id.getOrCrash();
        final _imageURL = await _cloudStorage.uploadAssetImage(
          imageToUpload: _imageAsset,
          folder: "invitations",
          name: _imageName,
        );
        invitation.imageURLs.add(_imageURL);
      }
       */
      final invitationDto = InvitationDto.fromDomain(invitation);
      _firestore.invitationCollection.doc(invitationDto.id).set(invitationDto);
      return right(unit);
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
