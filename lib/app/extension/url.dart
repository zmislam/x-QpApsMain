import '../config/constants/api_constant.dart';

extension UrlExtention on String {
  String get imageUrlBuild =>
      '${ApiConstant.SERVER_IP_PORT}/uploads/${toString()}';

  String get pageImageUrlBuild =>
      '${ApiConstant.SERVER_IP_PORT}/uploads/pages/${toString()}';
}
