class TareRange {
  final double tare;
  final double range;

  TareRange({
    required this.tare,
    required this.range,
  });

  factory TareRange.fromRaw(String rawTare, rawRange) {
    final _tare = double.tryParse(rawTare) ?? -1.0;
    final _range = double.tryParse(rawRange) ?? -1.0;
    return TareRange(tare: _tare, range: _range);
  }

  factory TareRange.fromJson(Map<String, dynamic> data) {
    final _tare = data['tare'] as double;
    final _range = data['range'] as double;
    return TareRange(tare: _tare, range: _range);
  }

  Map<String, double> toJson() {
    return {'tare': tare, 'range': range};
  }
}
