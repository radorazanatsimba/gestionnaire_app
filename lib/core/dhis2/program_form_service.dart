import 'package:d2_touch/d2_touch.dart';
import 'package:d2_touch/modules/metadata/data_element/entities/data_element.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage.entity.dart';
import 'package:d2_touch/modules/metadata/program/entities/program_stage_data_element.entity.dart';
import '../../model/data_element_with_options.dart';


class ProgramFormService {
  final D2Touch d2;

  ProgramFormService(this.d2);

  /// Charger un Program précis
  Future<Program> loadProgram(String programUid) async {
    final programs = await d2.programModule.program
        .where(attribute: 'id', value: programUid)
        .get();

    if (programs.isEmpty) {
      throw Exception("Programme $programUid introuvable localement");
    }
    return programs.first;
  }

  /// Charger un ProgramStage précis
  Future<ProgramStage> loadStage(String stageUid) async {
    final stages = await d2.programModule.programStage
        .where(attribute: 'id', value: stageUid)
        .get();

    if (stages.isEmpty) {
      throw Exception("ProgramStage $stageUid introuvable localement");
    }
    return stages.first;
  }

  /// Charger les ProgramStageDataElements du stage
  Future<List<ProgramStageDataElement>> loadStageElements(
      String stageUid) async {
    return await d2.programModule.programStageDataElement
        .where(attribute: 'programStage', value: stageUid)
        .get();
  }


  Future<List<DataElement>> loadDataElements(String programId, String stageId) async {
    final psdes = await d2.programModule.programStageDataElement
        .where(attribute: 'programStage', value: stageId)
        .get();

    final dataElements = <DataElement>[];

    for (final psde in psdes) {
      // Récupérer le DataElement lié
      final res = await d2.dataElementModule.dataElement
          .where(attribute: 'id', value: psde.dataElementId)
          .get();

      if (res.isNotEmpty) {
        final de = res.first;
        dataElements.add(de);
      } else {
        print("⚠️ DataElement ${psde.dataElementId} absent localement");
      }
    }

    return dataElements;
  }
  Future<List<DataElementWithOptions>> getOptionSetDataElements(
      String programId,
      String stageId) async {

    final psdes = await d2.programModule.programStageDataElement
        .where(attribute: 'programStage', value: stageId)
        .get();

    final result = <DataElementWithOptions>[];

    for (final psde in psdes) {
      // Récupérer le DataElement lié
      final res = await d2.dataElementModule.dataElement
          .where(attribute: 'id', value: psde.dataElementId)
          .get();

      if (res.isNotEmpty) {
        final de = res.first;
        final options = <Option>[];
        final psdeOptions = await d2.programModule.programStageDataElementOption
              .where(attribute: 'programStageDataElement', value: psde.id)
              .get();
        for (final o in psdeOptions) {
          if ((o.name != null && o.name!.isNotEmpty) ||
              (o.code != null && o.code!.isNotEmpty)) {
            options.add(Option(name: o.name, code: o.code));
          }
        }
        result.add(DataElementWithOptions(
          dataElementId: de.id!,
          options: options,
        ));
      } else {
        print("⚠️ DataElement ${psde.dataElementId} absent localement");
      }
    }

    return result;
  }

}

