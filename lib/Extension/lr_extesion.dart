import 'dart:convert' as convert;

extension LRObject on Object {
  ///转换成JSON字符串
  String convertToJson() {
    return convert.jsonEncode(this);
  }

  ///字符串转对象
  dynamic convertToObject() {
    return convert.jsonDecode(this as String);
  }
}
