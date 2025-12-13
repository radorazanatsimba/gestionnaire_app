import 'package:d2_touch/modules/metadata/metadata.dart';

typedef SyncProgressCallback = void Function(double progress, String message);

class SyncService {

  static Future<void> syncAll({
    required SyncProgressCallback onProgress,
  }) async {

    onProgress(0.1, "Téléchargement des unités organisationnelles");
    await MetadataModule.download(
      metadataTypes: ['organisationUnits'],
    );

    onProgress(0.3, "Téléchargement des programmes");
    await MetadataModule.download(
      metadataTypes: ['programs'],
    );

    onProgress(0.5, "Téléchargement des DataElements");
    await MetadataModule.download(
      metadataTypes: ['dataElements'],
    );

    onProgress(0.7, "Téléchargement des Tracked Entity Types");
    await MetadataModule.download(
      metadataTypes: ['trackedEntityTypes'],
    );

    onProgress(0.9, "Finalisation");
    await Future.delayed(const Duration(milliseconds: 300));

    onProgress(1.0, "Synchronisation terminée");
  }
}
