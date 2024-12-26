import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/data/core/misc/firebase/cloud_storage/storage_folder_enum.dart';

@lazySingleton
class CloudStorageService {
  final _instance = FirebaseStorage.instance;

  Future<void> deleteImage(String url) async =>
      _instance.refFromURL(url).delete();

  Future<String> uploadFileImage({
    required File imageToUpload,
    required String name,
    required StorageFolder folder,
  }) async {
    final storageReference = _instance.ref().child(folder.value()).child(
          name,
        );
    final uploadTask = storageReference.putFile(imageToUpload);
    final storageSnapshot = await uploadTask;
    return storageSnapshot.ref.getDownloadURL();
  }

  /// Uploads the given [XFile] type image or video to Cloud Storage
  Future<String> uploadXFile({
    required XFile mediaToUpload,
    required String name,
    required StorageFolder folder,
  }) async {
    final storageReference = _instance.ref().child(folder.value()).child(
          name,
        );
    final imageByteData = await mediaToUpload.readAsBytes();
    final uploadTask = storageReference.putData(
      imageByteData.buffer.asUint8List(),
    );
    final storageSnapshot = await uploadTask;
    return storageSnapshot.ref.getDownloadURL();
  }
}
