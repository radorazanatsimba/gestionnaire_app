class DataElement {
  final String id;
  final String name;
  final String valueType;

  DataElement({required this.id, required this.name, required this.valueType});
}

class ProgramStage {
  final String id;
  final String name;
  final bool repeatable;
  final List<DataElement> dataElements;

  ProgramStage({required this.id, required this.name, required this.repeatable, required this.dataElements});
}

class Program {
  final String id;
  final String name;
  final List<ProgramStage> stages;

  Program({required this.id, required this.name, required this.stages});
}
