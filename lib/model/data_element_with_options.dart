
class Option {
  final String? name;
  final String? code;

  Option({this.name, this.code});

  @override
  String toString() => 'Option(name: $name, code: $code)';
}

class DataElementWithOptions {
  final String dataElementId;
  final List<Option> options;

  DataElementWithOptions({
    required this.dataElementId,
    required this.options,
  });

  @override
  String toString() =>
      'DataElementWithOptions(id: $dataElementId, options: $options)';
}

