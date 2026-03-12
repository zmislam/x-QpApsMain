import '../../config/constants/api_constant.dart';

extension StringImageUrlExtensions on String {
  String get formatedProfileUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/$this';
  }

  String get formatedGroupProfileUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/group/$this';
  }

  String get formatedPageProfileUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/pages/$this';
  }

  String get formatedStoryUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/story/$this';
  }

  String get formatedPostUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/posts/$this';
  }

  String get formatedHelpSupportUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/support/$this';
  }

  String get formatedPagesUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/pages/posts/$this';
  }

  String get formatedReelUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$this';
  }

  String get formatedProfileReelUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/reels/thumbnails/$this';
  }

  String get formatedVideoUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/posts/$this';
  }

  String get formatedLiveStreamViewUrl {
    return '${ApiConstant.SERVER_IP}:96/live/$this/index.m3u8';
  }

  String get formatedThumbnailUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/posts/thumbnails/$this';
  }

  String get formatedAdsUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/adsStorage/$this';
  }

  String get formatedProductUrlLive {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/product/$this';
  }

  String get formatedStoreUrlLive {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/story/$this';
  }

  String get formatedReturnQrUrlLive {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/qr_code/$this';
  }

  String get formatedProductReviewUrlLive {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/reviews/$this';
  }

  String get formatedProductOrderReFundUrlLive {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/order_refund/$this';
  }

  String get formatedFeelingUrl {
    return '${ApiConstant.SERVER_IP_PORT}/assets/logo/$this';
  }

  String get formatedAudioThumbnailUrl {
    return '${ApiConstant.SERVER_IP_PORT}/uploads/audio/thumbnails/$this';
  }

  String get formateAsAudioThumbnailUrl => '${ApiConstant.SERVER_IP_PORT}/uploads/audio/thumbnails/$this';
}
