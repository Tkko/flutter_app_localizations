class LocalizationData {
  // From assets
  final Map<String, String> local;

  // Fetched from BE
  final Map<String, String> cached;

  LocalizationData({
    this.cached = const {},
    this.local = const {},
  });

  String get(String? key, List<String>? args, Map<String, String>? namedArgs) {
    if (key == null) return '';
    final translatedStr = cached[key] ?? local[key] ?? key;
    return translatedStr;
  }

  @override
  String toString() {
    return 'LocalizationData{local: $local, cached: $cached}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizationData && runtimeType == other.runtimeType && local == other.local && cached == other.cached;

  @override
  int get hashCode => local.hashCode ^ cached.hashCode;
}
