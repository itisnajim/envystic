/// A class that defines the priority order for loading environment variable values.
///
/// This class determines the sequence in which environment variable values are loaded.
/// It provides three priority levels, where a higher integer value implies a higher priority:
/// * [system] A higher integer value indicates a higher priority for system-defined environment variables.
/// * [stored] A higher integer value indicates a higher priority for environment variables stored within the generated class.
/// * [custom] A higher integer value indicates that the field will use the `Future<Object?> Function()? customLoader`
///   instead of loading from the system or the pre-loaded (encoded values in the generated class).
class ValuesPriority {
  /// Priority assigned to system-defined environment variables.
  final int system;

  /// Priority assigned to stored (persistent) environment variables within the generated class.
  final int stored;

  /// Priority assigned to user-defined environment variables.
  final int custom;

  /// Creates an instance of the [ValuesPriority] class.
  ///
  /// Use the [system], [stored], and [custom] parameters to specify
  /// the priority levels for different sources of environment variable values.
  /// A higher integer value implies a higher priority.
  const ValuesPriority({
    this.system = 1,
    this.stored = 2,
    this.custom = 3,
  });

  String? getValue(
    String key, {
    required Map<String, String?> systemPairs,
    required Map<String, String?> storedPairs,
    required Object? Function()? customLoader,
  }) {
    final sources = [
      _Source(priority: custom, value: customLoader?.call()),
      _Source(priority: stored, value: storedPairs[key]),
      _Source(priority: system, value: systemPairs[key]),
    ];

    sources.sort((a, b) => b.priority.compareTo(a.priority));

    final source = sources.where((source) => source.value != null).firstOrNull;

    return source?.value?.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValuesPriority &&
          system == other.system &&
          stored == other.stored &&
          custom == other.custom;

  @override
  int get hashCode => system.hashCode ^ stored.hashCode ^ custom.hashCode;
}

class _Source {
  final int priority;
  final Object? value;

  const _Source({
    required this.priority,
    required this.value,
  });
}
