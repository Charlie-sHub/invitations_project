import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

/// Repository for the Home page.
abstract class HomeRepositoryInterface {
  /// Gets a Set with the example Invitations
  Future<Either<Failure, Set<Invitation>>> getExampleInvitations( );
}
