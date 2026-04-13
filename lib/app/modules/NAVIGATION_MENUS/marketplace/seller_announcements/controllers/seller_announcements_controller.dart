import 'package:get/get.dart';
import '../../../../../models/seller_announcement_model.dart';
import '../../../../../repository/seller_announcement_repository.dart';

class SellerAnnouncementsController extends GetxController {
  final SellerAnnouncementRepository _repo = SellerAnnouncementRepository();

  RxList<SellerAnnouncementModel> announcements =
      <SellerAnnouncementModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  int _page = 1;
  int _total = 0;
  static const int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    isLoading.value = true;
    _page = 1;
    final result = await _repo.getAnnouncements(page: _page, limit: _limit);
    announcements.value = result.announcements;
    _total = result.total;
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value) return;
    if (announcements.length >= _total) return;
    isLoadingMore.value = true;
    _page++;
    final result = await _repo.getAnnouncements(page: _page, limit: _limit);
    announcements.addAll(result.announcements);
    _total = result.total;
    isLoadingMore.value = false;
  }

  bool get hasMore => announcements.length < _total;
}
