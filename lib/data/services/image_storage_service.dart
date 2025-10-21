import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tourdecks/data/enums/image_options.dart';
import 'package:tourdecks/global/labels.dart';
import 'package:tourdecks/hive/hive_registrar.g.dart';
import 'package:tourdecks/models/card.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/utils/dialog_utils.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return ImageStorageService();
});

class ImageStorageService {
  //Returns local path to the final image from camera or gallery after compression
  Future<String?> openPickerCameraOrGallery() async {
    final optionsMap = {
      ImageOptions.captureWithCamera: Labels.CaptureOption,
      ImageOptions.selectFromLibrary: Labels.LibraryOption,
    };

    final requestedSelection = await DialogUtils().showDialogWithOptions(
      optionsMap,
    );

    final ImagePicker picker = ImagePicker();

    XFile? image;

    switch (requestedSelection) {
      case ImageOptions.captureWithCamera:
        image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 5,
        );
        break;
      case ImageOptions.selectFromLibrary:
        image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 5,
        );
        break;
      case null:
        return null;
    }

    if (image != null) {
      final String path = (await getApplicationDocumentsDirectory()).path;

      final imageFile = File(image.path);

      var uuid = Uuid();
      final File storedImage = await imageFile.copy('$path/${uuid.v4()}');

      return storedImage.path;
    }

    return null;
  }

  //Testing functions
  Future<void> storeTestingImages() async {
    final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(
      rootBundle,
    );
    final List<String> assets =
        assetManifest
            .listAssets()
            .where((e) => e.contains('assets/images/test'))
            .toList();

    assets.forEach((assetPath) async {
      final byteData = await rootBundle.load(assetPath);
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/${assetPath.split('/').last}';
      final file = File(filePath);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    });
  }

  Future<List<String>> _getTestImagesPaths() async {
    final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(
      rootBundle,
    );
    return assetManifest
        .listAssets()
        .where((e) => e.contains('assets/images/test'))
        .toList();
  }

  Future<String> getTestImagePathByIndex(int index) async {
    final List<String> assets = await _getTestImagesPaths();

    final String path = (await getApplicationDocumentsDirectory()).path;
    return '$path/${assets[index].split('/').last}';
  }

  Future<String> getRandomTestImagePath() async {
    final List<String> assets = await _getTestImagesPaths();

    final random = Random();
    final index =
        random.nextInt(8) + 1; // Random number between 1 and 8 (inclusive)

    final String path = (await getApplicationDocumentsDirectory()).path;
    return '$path/${assets[index - 1].split('/').last}'; // Subtract 1 for 0-based indexing
  }
}
