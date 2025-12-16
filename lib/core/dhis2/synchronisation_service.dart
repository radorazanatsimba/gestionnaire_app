import 'package:d2_touch/shared/models/request_progress.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/sync_progress_provider.dart';
import '../provider/d2_init.dart';

class SynchronisationService {
  Future<void> syncMetadata(
      D2Provider d2Provider,
      SyncProgressProvider progressProvider,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final d2 = d2Provider.d2;

    Future<void> download(
        Future<void> Function(Function(RequestProgress, Object)) fn,
        ) async {
      await fn((progress, status) {
        progressProvider.update(progress, status);
      });
    }

    await download(d2.programModule.program.download);
    await download(d2.programModule.programStage.download);
    await download(d2.programModule.programStageDataElement.download);
    await download(d2.programModule.programStageDataElementOption.download);
    await download(d2.dataElementModule.dataElement.download);
    await download(d2.dataSetModule.dataSet.download);
    await download(d2.dataSetModule.dataSetElement.download);
    await download(d2.dataSetModule.dataSetElementOption.download);
    await download(d2.dataSetModule.categoryOptionCombo.download);

    await prefs.setBool('metadata_downloaded', true);
  }
}
