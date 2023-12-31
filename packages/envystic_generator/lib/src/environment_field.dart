import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';

class EnvironmentField {
  final String name;
  final String? nameOverride;
  final String? customLoader;
  final DartType type;
  final DartObject? defaultValue;

  const EnvironmentField(
    this.name,
    this.nameOverride,
    this.customLoader,
    this.type,
    this.defaultValue,
  );
}
