import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

const supportedTypes = {
  'String': String,
  'int': int,
  'double': double,
  'num': num,
  'bool': bool,
  'Enum': Enum,
  'dynamic': dynamic,
  'Object': Object,
};

Type getType(DartType dartType) {
  if (dartType.isDartCoreString) return supportedTypes['String']!;
  if (dartType.isDartCoreInt) return supportedTypes['int']!;
  if (dartType.isDartCoreDouble) return supportedTypes['double']!;
  if (dartType.isDartCoreNum) return supportedTypes['num']!;
  if (dartType.isDartCoreBool) return supportedTypes['bool']!;
  if (dartType.isEnum) return supportedTypes['Enum']!;
  if (dartType.isDartCoreObject) return supportedTypes['Object']!;
  if (dartType is DynamicType) return supportedTypes['dynamic']!;
  throw "Type `$dartType` not supported";
}

Type getTypeFromString(String expression) {
  if (int.tryParse(expression) != null) {
    return supportedTypes['int']!;
  } else if (double.tryParse(expression) != null) {
    return supportedTypes['double']!;
  } else if (num.tryParse(expression) != null) {
    return supportedTypes['num']!;
  } else if ([
    '1',
    '0',
    'true',
    'false',
    'no',
  ].contains(expression.toLowerCase())) {
    return supportedTypes['bool']!;
  } else if (expression.isEmpty) {
    return supportedTypes['dynamic']!;
  } else {
    return supportedTypes['String']!;
  }
}
