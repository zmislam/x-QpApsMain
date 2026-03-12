import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../repository/page_repository.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/category.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/location_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/logger/logger.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../page_profile/model/page_profile_model.dart';
import '../model/allpages_model.dart';
import '../model/invitation_model.dart';
import '../model/invites_page_model.dart';
import '../model/manage_page_model.dart';
import '../model/mypage_model.dart';

class PagesController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  final GlobalKey<FormState> formKey = GlobalKey();

  RxInt view = 0.obs;

  Rx<List<XFile>> profilefiles = Rx([]);
  Rx<List<XFile>> coverfiles = Rx([]);
  RxBool isLoadingUserPages = false.obs;
  RxBool isLoadingDiscoverPages = false.obs;
  RxBool isSaveButtonEnabled = false.obs;
  RxBool isLocationLoading = false.obs;
  RxBool isLoadingFriendList = false.obs;
  RxBool switchValue = true.obs;
  RxBool switchValue1 = true.obs;

  Rx<List<MyPagesModel>> myPagesList = Rx([]);

  Rx<List<AllLocation>> locationList = Rx([]);
  Rx<List<MyPagesModel>> categoriesList = Rx([]);
  Rx<List<AllPagesModel>> allpagesList = Rx([]);
  Rx<List<ManagePageModel>> managepagesList = Rx([]);
  Rx<List<InvitesPageModel>> invitesPageList = Rx([]);
  Rx<List<AllPagesModel>> followedPageList = Rx([]);
  Rx<List<PageInvitationModel>> pageInvitationList = Rx([]);
  Rx<List<PageInvitationModel>> selectedPageInvitationList = Rx([]);
  RxList<AllPagesModel> filteredPagesList = <AllPagesModel>[].obs;

// RxList<AllPagesModel> allpagesList = <AllPagesModel>[].obs;
  Rx<PageProfileModel?> pageProfileModel = Rx(null);
  Rx<List<bool>> selectedNames = Rx([]);
  RxString categoryValue = categoryList.first.obs;
  MyPagesModel? myPagesModel;

  RxString dropdownValue = privacyList.first.obs;

  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController zipCodeController;
  late TextEditingController descriptionController;
  final ScrollController myPageScrollController = ScrollController();
  final ScrollController discoverPageScrollController = ScrollController();
  late ScrollController followedPageScrollController;
  late ScrollController invitePageScrollController;
  Rx<AllLocation?> selectedLocation = Rx(null);
  String onCLocationChanged = '';
  Timer? debounce;
  RxBool isAccepted = false.obs;
  String? pageUserName;
  String? selectedCategory;
  final count = 0.obs;
  var selectedInvitations = <bool>[].obs;
  int skip = 0;
  int limit = 10;
  RxInt pageCount = 0.obs;

  final PageRepository pageRepository = PageRepository();

  void initialUpdatePageList({required List<AllPagesModel> suggestedPages}) {
    allpagesList.value = List.from(suggestedPages);
    isLoadingUserPages.value = true;
    isLoadingDiscoverPages.value = true;
    allpagesList.refresh();
  }
  //-------------------------------------- PICK FILES ----------------------------//

  Future<void> pickProfilesFiles() async {
    final ImagePicker picker = ImagePicker();
    XFile? mediaXFiles = await picker.pickImage(source: ImageSource.gallery);
    profilefiles.value.add(mediaXFiles!);
    profilefiles.refresh();
  }

  Future<void> pickCoverFiles() async {
    final ImagePicker picker = ImagePicker();
    XFile? mediaXFiles = await picker.pickImage(source: ImageSource.gallery);
    coverfiles.value.add(mediaXFiles!);
    coverfiles.refresh();
  }

  //-------------------------------------- Create Page ----------------------------//
  Future<void> createPage() async {
    final ApiResponse response = await pageRepository.createPage(
      pageName: nameController.text,
      pageBio: bioController.text,
      selectedCategory: selectedCategory ?? '',
      onCLocationChanged: onCLocationChanged,
      zipCode: zipCodeController.text,
      pageDescription: descriptionController.text,
      profileFiles: profilefiles.value.first,
      coverFiles: coverfiles.value.first,
    );

    if (response.isSuccessful) {
      Get.back();
      getMyPages(forceFetch: true);
      showSuccessSnackkbar(message: 'Page created successfully');
    } else {
      debugPrint('');
    }
  }

  //-------------------------------------- Get My Pages ----------------------------//
  Future getMyPages({bool? forceFetch}) async {
    myPagesList.value.clear();
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await pageRepository.getMyPages(
        skip: skip, limit: limit, forceFetch: forceFetch);

    if (apiResponse.isSuccessful) {
      //@ Using total page count in page count for page ignition
      pageCount.value = apiResponse.pageCount ?? 0;
      Log.e('My Pages Count: ${pageCount.value}');
      List<MyPagesModel> newPages = (apiResponse.data as List<MyPagesModel>);
      myPagesList.value.addAll(newPages);
      myPagesList.refresh();
    }
    isLoadingUserPages.value = false;
  }

  //--------------------------------------Get  Manage Pages ----------------------------//
  Future getManagePages() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await pageRepository.getAllMyManagedPages();

    if (apiResponse.isSuccessful) {
      managepagesList.value =
          List.from(apiResponse.data as List<ManagePageModel>);
    }
    isLoadingUserPages.value = false;
  }

  //----------------------------------Get Page details--------------------------------//

  Future getPageDetails() async {
    ApiResponse apiResponse = await pageRepository.getPageDetailsByName(
        name: myPagesModel?.pageUserName);
    if (apiResponse.isSuccessful) {
      pageProfileModel.value =
          PageProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      debugPrint('Response success');
    } else {
      debugPrint('Response failed');
    }
  }

  //--------------------------------------Get All Pages ----------------------------//

  bool isDiscoverFetching = false;
  bool hasMoreDiscover = true;            // how many items we've loaded so far
  final int pageSize = 12;

  Future<void> getAllPages({bool initial = false}) async {
    if (isDiscoverFetching) return;
    if (!hasMoreDiscover && !initial) return;

    isDiscoverFetching = true;
    isLoadingDiscoverPages.value = true;
    isLoadingUserPages.value = true;

    try {
      if (initial) {
        skip = 0;
        hasMoreDiscover = true;
        allpagesList.value.clear();
      }

      final ApiResponse apiResponse =
      await pageRepository.getAllPages(skip: skip, limit: pageSize);

      if (!apiResponse.isSuccessful) {
        // API failed — stop fetching more to avoid loops
        hasMoreDiscover = false;
        return;
      }

      // Update pageCount if provided by server
      pageCount.value = apiResponse.pageCount ?? pageCount.value;

      // Normalize response.data to List<dynamic>
      final rawList = (apiResponse.data is List) ? apiResponse.data as List : <dynamic>[];

      // Convert raw items to AllPagesModel robustly
      final List<AllPagesModel> fetched = <AllPagesModel>[];
      for (final item in rawList) {
        if (item == null) continue;
        if (item is AllPagesModel) {
          fetched.add(item);
        } else if (item is Map<String, dynamic>) {
          fetched.add(AllPagesModel.fromMap(item));
        } else if (item is Map) {
          // sometimes map keys are dynamic
          fetched.add(AllPagesModel.fromMap(Map<String, dynamic>.from(item)));
        } else {
          // unexpected type — try to skip it
          continue;
        }
      }

      // If initial load, just add them
      if (initial) {
        allpagesList.value.addAll(fetched);
        skip = allpagesList.value.length;
      } else {
        final existingIds = allpagesList.value
            .map((e) => e.id)
            .whereType<String>()
            .toSet();

        final toAppend = fetched
            .where((p) => p.id != null && !existingIds.contains(p.id))
            .toList();

        if (toAppend.isNotEmpty) {
          allpagesList.value.addAll(toAppend);
          skip += toAppend.length;
        }
      }

      // If server returned fewer than pageSize, no more pages
      if (fetched.length < pageSize) {
        hasMoreDiscover = false;
      }
    } catch (e, st) {
      debugPrint('Pagination Error: $e\n$st');
      // On error, optionally keep hasMoreDiscover true so user can retry,
      // but to be safe we set false to avoid loops. You can change this.
      hasMoreDiscover = false;
    } finally {
      isDiscoverFetching = false;
      isLoadingDiscoverPages.value = false;
      isLoadingUserPages.value = false;
      allpagesList.refresh();
    }
  }


//==========================================Discover page search =============================//
  Future<void> getSearchPage(String text) async {
    isLoadingUserPages.value = true;
    final apiResponse = await pageRepository.searchPageByText(text: text);
    if (apiResponse.isSuccessful) {
      allpagesList.value = List.from(apiResponse.data as List<AllPagesModel>);
      allpagesList.refresh();
    } else {
      debugPrint('❌ Error searching pages');
    }
    isLoadingUserPages.value = false;
  }

  //-------------------------------------- Get Followed Page ----------------------------//

  Future getFollowedPages({bool? forceFetch}) async {
    isLoadingUserPages.value = true;
    followedPageList.value.clear();
    ApiResponse apiResponse = await pageRepository.getFollowedPages(
        skip: 0, limit: limit, forceFetch: forceFetch);

    if (apiResponse.isSuccessful) {
      //@ Using total page count in page count for page ignition
      pageCount.value = apiResponse.pageCount ?? 0;
      List<AllPagesModel> newPages =
          List.from(apiResponse.data as List<AllPagesModel>);
      // getMyPages();
      followedPageList.value.addAll(newPages);
      followedPageList.refresh();
    }
    isLoadingUserPages.value = false;
  }

  //-------------------------------------- Invited Page ----------------------------//

  Future<void> getInvites() async {
    isLoadingUserPages.value = true;
    invitesPageList.value.clear();
    final ApiResponse apiResponse =
        await pageRepository.getInvites(skip: skip, limit: limit);
    if (apiResponse.isSuccessful) {
      //@ Using total page count in page count for page ignition
      pageCount.value = apiResponse.pageCount ?? 0;
      List<InvitesPageModel> newPages =
          List.from(apiResponse.data as List<InvitesPageModel>);
      invitesPageList.value.addAll(newPages);
      invitesPageList.refresh();
    }
    isLoadingUserPages.value = false;
  }

//================================= Page Invitation --------------------------------//

// RxString keyword =''.obs;
  Future getPagesInvites(String pageId) async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse =
        await pageRepository.getPageInvitesByID(pageId: pageId);

    if (apiResponse.isSuccessful) {
      pageInvitationList.value = (apiResponse.data as List)
          .map(
            (e) => PageInvitationModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }

  //-------------------------------------- All Location ----------------------------//

  // Future<List<AllLocation>> getLocation(String locationName) async {
  //   isLocationLoading.value = true;
  //   final ApiResponse response = await _apiCommunication.doGetRequest(
  //     apiEndPoint: 'global-search-location?search=$locationName',
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //   );
  //   isLocationLoading.value = false;
  //   if (response.isSuccessful) {
  //     locationList.value =
  //         (((response.data as Map<String, dynamic>)['results']) as List)
  //             .map((element) => AllLocation.fromJson(element))
  //             .toList();
  //   } else {
  //     debugPrint('');
  //   }
  //   return locationList.value;
  // }

  // #┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  //  ┃ TODO:  Need other repo for the  [getFutureLocation] function           ┃
  // #┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<List<AllLocation>> getFutureLocation(String locationName) async {
    isLocationLoading.value = true;
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'global-search-location?search=$locationName',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    isLocationLoading.value = false;
    if (response.isSuccessful) {
      locationList.value =
          (((response.data as Map<String, dynamic>)['results']) as List)
              .map((element) => AllLocation.fromJson(element))
              .toList();

      update();
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  //-------------------------------------- declined-invitation ----------------------------//

  Future<void> declinedPage(
    String invitationId,
  ) async {
    final ApiResponse response = await pageRepository.actionOnPageInvite(
      invitationId: invitationId,
      acceptInvite: false,
    );
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Pages Invitation declined successfully');
      getInvites();
    } else {
      debugPrint('');
    }
  }

  //-------------------------------------- accept-invitation ----------------------------//

  Future<void> acceptPage(String invitationId, String pageId) async {
    final ApiResponse response = await pageRepository.actionOnPageInvite(
      invitationId: invitationId,
      acceptInvite: true,
    );
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Pages Invitation accepted successfully');
      getInvites();
    } else {
      debugPrint('');
    }
  }

  //-------------------------------------- follow-page ----------------------------//

  Future<void> followPage(String pageId) async {
    final ApiResponse response = await pageRepository.followPage(pageId);
    if (response.isSuccessful) {
      // Remove the followed page from discover list
      allpagesList.value.removeWhere((page) => page.id == pageId);
      allpagesList.refresh();
      showSuccessSnackkbar(message: 'Successfully followed the page');
    } else {
      debugPrint('❌ Failed to follow page');
    }
  }
  //==========================================Send Friend invites =====================================//

  Future sendFriendInvitation(
    String pageId,
  ) async {
    isLoadingFriendList.value = true;
    ApiResponse apiResponse =
        await pageRepository.sendPageFollowInviteToFriends(
            pageId: pageId,
            userIds: selectedPageInvitationList.value
                .map((model) => model.friend?.id)
                .toList());

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'page Invitation Send successfully');
    }
    isLoadingUserPages.value = false;
  }

  //=========================================== For Scrolling List View
  void _scrollListenerForDiscover() {
    if (!discoverPageScrollController.hasClients) return;
    if (isDiscoverFetching) return;
    if (!hasMoreDiscover) return;

    final pos = discoverPageScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      // load next
      getAllPages();
    }
  }

  Future<void> _scrollListenerForMyPages() async {
    if (myPageScrollController.position.pixels ==
        myPageScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (skip * limit < pageCount.value) {
        skip += 1;
        myPagesList.value.clear();
        await getMyPages();
      }
    }
  }

  Future<void> _scrollListenerForFollowedPages() async {
    if (followedPageScrollController.position.pixels ==
        followedPageScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (skip * limit < pageCount.value) {
        skip += 1;
        followedPageList.value.clear();
        await getFollowedPages();
      }
    }
  }

  Future<void> _scrollListenerForInvitePages() async {
    if (invitePageScrollController.position.pixels ==
        invitePageScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (skip * limit < pageCount.value) {
        skip += 1;
        invitesPageList.value.clear();
        await getInvites();
      }
    }
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    nameController = TextEditingController();
    bioController = TextEditingController();
    zipCodeController = TextEditingController();
    descriptionController = TextEditingController();
    followedPageScrollController = ScrollController();
    invitePageScrollController = ScrollController();
    myPagesModel = Get.arguments;
    await getAllPages();
    super.onInit();
  }

  @override
  void onReady() {
    discoverPageScrollController.addListener(_scrollListenerForDiscover);
    myPageScrollController.addListener(_scrollListenerForMyPages);
    followedPageScrollController.addListener(_scrollListenerForFollowedPages);
    invitePageScrollController.addListener(_scrollListenerForInvitePages);
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    debounce?.cancel();
    discoverPageScrollController.dispose();
    myPageScrollController.dispose();
    followedPageScrollController.dispose();
    invitePageScrollController.dispose();
    pageCount.value = 0;
    super.onClose();
  }

  void increment() => count.value++;
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../../../../repository/page_repository.dart';
//
// import '../../../../../../../config/constants/api_constant.dart';
// import '../../../../../../../data/category.dart';
// import '../../../../../../../data/login_creadential.dart';
// import '../../../../../../../data/post_local_data.dart';
// import '../../../../../../../models/api_response.dart';
// import '../../../../../../../models/location_model.dart';
// import '../../../../../../../services/api_communication.dart';
// import '../../../../../../../utils/snackbar.dart';
// import '../../page_profile/model/page_profile_model.dart';
// import '../model/allpages_model.dart';
// import '../model/invitation_model.dart';
// import '../model/invites_page_model.dart';
// import '../model/manage_page_model.dart';
// import '../model/mypage_model.dart';
//
// class PagesController extends GetxController {
//   late final ApiCommunication _apiCommunication;
//   late final LoginCredential loginCredential;
//   final GlobalKey<FormState> formKey = GlobalKey();
//
//   RxInt view = 0.obs;
//
//   Rx<List<XFile>> profilefiles = Rx([]);
//   Rx<List<XFile>> coverfiles = Rx([]);
//   RxBool isLoadingUserPages = false.obs;
//   RxBool isLoadingDiscoverPages = false.obs;
//   RxBool isSaveButtonEnabled = false.obs;
//   RxBool isLocationLoading = false.obs;
//   RxBool isLoadingFriendList = false.obs;
//   RxBool switchValue = true.obs;
//   RxBool switchValue1 = true.obs;
//
//   Rx<List<MyPagesModel>> myPagesList = Rx([]);
//
//   Rx<List<AllLocation>> locationList = Rx([]);
//   Rx<List<MyPagesModel>> categoriesList = Rx([]);
//   Rx<List<AllPagesModel>> allpagesList = Rx([]);
//   Rx<List<ManagePageModel>> managepagesList = Rx([]);
//   Rx<List<InvitesPageModel>> invitesPageList = Rx([]);
//   Rx<List<AllPagesModel>> followedPageList = Rx([]);
//   Rx<List<PageInvitationModel>> pageInvitationList = Rx([]);
//   Rx<List<PageInvitationModel>> selectedPageInvitationList = Rx([]);
//   RxList<AllPagesModel> filteredPagesList = <AllPagesModel>[].obs;
//
// // RxList<AllPagesModel> allpagesList = <AllPagesModel>[].obs;
//   Rx<PageProfileModel?> pageProfileModel = Rx(null);
//   Rx<List<bool>> selectedNames = Rx([]);
//   RxString categoryValue = categoryList.first.obs;
//   MyPagesModel? myPagesModel;
//
//   RxString dropdownValue = privacyList.first.obs;
//
//   late TextEditingController nameController;
//   late TextEditingController bioController;
//   late TextEditingController zipCodeController;
//   late TextEditingController descriptionController;
//   late ScrollController discoverPageScrollController;
//   late ScrollController followedPageScrollController;
//   late ScrollController myPageScrollController;
//   late ScrollController invitePageScrollController;
//   Rx<AllLocation?> selectedLocation = Rx(null);
//   String onCLocationChanged = '';
//   Timer? debounce;
//   RxBool isAccepted = false.obs;
//   String? pageUserName;
//   String? selectedCategory;
//   final count = 0.obs;
//   var selectedInvitations = <bool>[].obs;
//   int skip = 0;
//   int limit = 10;
//   RxInt pageCount = 0.obs;
//
//   final PageRepository pageRepository = PageRepository();
//
//   void initialUpdatePageList({required List<AllPagesModel> suggestedPages}) {
//     allpagesList.value = List.from(suggestedPages);
//     isLoadingUserPages.value = true;
//     isLoadingDiscoverPages.value = true;
//     allpagesList.refresh();
//   }
//   //-------------------------------------- PICK FILES ----------------------------//
//
//   Future<void> pickProfilesFiles() async {
//     final ImagePicker picker = ImagePicker();
//     XFile? mediaXFiles = await picker.pickImage(source: ImageSource.gallery);
//     profilefiles.value.add(mediaXFiles!);
//     profilefiles.refresh();
//   }
//
//   Future<void> pickCoverFiles() async {
//     final ImagePicker picker = ImagePicker();
//     XFile? mediaXFiles = await picker.pickImage(source: ImageSource.gallery);
//     coverfiles.value.add(mediaXFiles!);
//     coverfiles.refresh();
//   }
//
//   //-------------------------------------- Create Page ----------------------------//
//   Future<void> createPage() async {
//     final ApiResponse response = await pageRepository.createPage(
//       pageName: nameController.text,
//       pageBio: bioController.text,
//       selectedCategory: selectedCategory ?? '',
//       onCLocationChanged: onCLocationChanged,
//       zipCode: zipCodeController.text,
//       pageDescription: descriptionController.text,
//       profileFiles: profilefiles.value.first,
//       coverFiles: coverfiles.value.first,
//     );
//
//     if (response.isSuccessful) {
//       Get.back();
//       getMyPages(forceFetch: true);
//       showSuccessSnackkbar(message: 'Page created successfully');
//     } else {
//       debugPrint('');
//     }
//   }
//
//   //-------------------------------------- Get My Pages ----------------------------//
//   Future getMyPages({bool? forceFetch}) async {
//     myPagesList.value.clear();
//     isLoadingUserPages.value = true;
//     ApiResponse apiResponse = await pageRepository.getMyPages(
//         skip: skip, limit: limit, forceFetch: forceFetch);
//
//     if (apiResponse.isSuccessful) {
//       //@ Using total page count in page count for page ignition
//       pageCount.value = apiResponse.pageCount ?? 0;
//
//       List<MyPagesModel> newPages = (apiResponse.data as List<MyPagesModel>);
//       myPagesList.value.addAll(newPages);
//       myPagesList.refresh();
//     }
//     isLoadingUserPages.value = false;
//   }
//
//   //--------------------------------------Get  Manage Pages ----------------------------//
//   Future getManagePages() async {
//     isLoadingUserPages.value = true;
//     ApiResponse apiResponse = await pageRepository.getAllMyManagedPages();
//
//     if (apiResponse.isSuccessful) {
//       managepagesList.value =
//           List.from(apiResponse.data as List<ManagePageModel>);
//     }
//     isLoadingUserPages.value = false;
//   }
//
//   //----------------------------------Get Page details--------------------------------//
//
//   Future getPageDetails() async {
//     ApiResponse apiResponse = await pageRepository.getPageDetailsByName(
//         name: myPagesModel?.pageUserName);
//     if (apiResponse.isSuccessful) {
//       pageProfileModel.value =
//           PageProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
//       debugPrint('Response success');
//     } else {
//       debugPrint('Response failed');
//     }
//   }
//
//   //--------------------------------------Get All Pages ----------------------------//
//   Future getAllPages({int? skip}) async {
//     isLoadingUserPages.value = true;
//     isLoadingDiscoverPages.value = true;
//     ApiResponse apiResponse = await pageRepository.getAllPages(
//         skip: skip ?? allpagesList.value.length, limit: 12);
//
//     if (apiResponse.isSuccessful) {
//       //@ Using total page count in page count for page ignition
//       pageCount.value = apiResponse.pageCount ?? 0;
//
//       allpagesList.value = List.from(apiResponse.data as List);
//       List<AllPagesModel> newPages = [];
//       for (final item in allpagesList.value) {
//         newPages.add(item);
//       }
//       //     List.from(apiResponse.data as List<AllPagesModel>);
//       // allpagesList.value.addAll(newPages);
//
//       final existingIds =
//       allpagesList.value.map((e) => e.id).where((id) => id != null).toSet();
//       final uniquePages = newPages
//           .where((element) =>
//       element.id != null && !existingIds.contains(element.id))
//           .toList();
//
//       allpagesList.value.addAll(uniquePages);
//
//       allpagesList.refresh();
//     }
//     isLoadingUserPages.value = false;
//     isLoadingDiscoverPages.value = false;
//   }
//
// //==========================================Discover page search =============================//
//   Future<void> getSearchPage(String text) async {
//     isLoadingUserPages.value = true;
//
//     final apiResponse = await pageRepository.searchPageByText(text: text);
//     isLoadingUserPages.value = false;
//
//     if (apiResponse.isSuccessful) {
//       allpagesList.value = List.from(apiResponse.data as List<AllPagesModel>);
//       allpagesList.refresh();
//     } else {
//       debugPrint('Error');
//     }
//   }
//
//   //-------------------------------------- Get Followed Page ----------------------------//
//
//   Future getFollowedPages({bool? forceFetch}) async {
//     isLoadingUserPages.value = true;
//     followedPageList.value.clear();
//     ApiResponse apiResponse = await pageRepository.getFollowedPages(
//         skip: skip, limit: limit, forceFetch: forceFetch);
//
//     if (apiResponse.isSuccessful) {
//       //@ Using total page count in page count for page ignition
//       pageCount.value = apiResponse.pageCount ?? 0;
//       List<AllPagesModel> newPages =
//       List.from(apiResponse.data as List<AllPagesModel>);
//       // getMyPages();
//       followedPageList.value.addAll(newPages);
//       followedPageList.refresh();
//     }
//     isLoadingUserPages.value = false;
//   }
//
//   //-------------------------------------- Invited Page ----------------------------//
//
//   Future<void> getInvites() async {
//     isLoadingUserPages.value = true;
//     invitesPageList.value.clear();
//     final ApiResponse apiResponse =
//     await pageRepository.getInvites(skip: skip, limit: limit);
//     if (apiResponse.isSuccessful) {
//       //@ Using total page count in page count for page ignition
//       pageCount.value = apiResponse.pageCount ?? 0;
//       List<InvitesPageModel> newPages =
//       List.from(apiResponse.data as List<InvitesPageModel>);
//       invitesPageList.value.addAll(newPages);
//       invitesPageList.refresh();
//     }
//     isLoadingUserPages.value = false;
//   }
//
// //================================= Page Invitation --------------------------------//
//
// // RxString keyword =''.obs;
//   Future getPagesInvites(String pageId) async {
//     isLoadingUserPages.value = true;
//     ApiResponse apiResponse =
//     await pageRepository.getPageInvitesByID(pageId: pageId);
//
//     if (apiResponse.isSuccessful) {
//       pageInvitationList.value = (apiResponse.data as List)
//           .map(
//             (e) => PageInvitationModel.fromMap(e),
//       )
//           .toList();
//     }
//     isLoadingUserPages.value = false;
//   }
//
//   //-------------------------------------- All Location ----------------------------//
//
//   // Future<List<AllLocation>> getLocation(String locationName) async {
//   //   isLocationLoading.value = true;
//   //   final ApiResponse response = await _apiCommunication.doGetRequest(
//   //     apiEndPoint: 'global-search-location?search=$locationName',
//   //     responseDataKey: ApiConstant.FULL_RESPONSE,
//   //   );
//   //   isLocationLoading.value = false;
//   //   if (response.isSuccessful) {
//   //     locationList.value =
//   //         (((response.data as Map<String, dynamic>)['results']) as List)
//   //             .map((element) => AllLocation.fromJson(element))
//   //             .toList();
//   //   } else {
//   //     debugPrint('');
//   //   }
//   //   return locationList.value;
//   // }
//
//   // #┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//   //  ┃ TODO:  Need other repo for the  [getFutureLocation] function           ┃
//   // #┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
//
//   Future<List<AllLocation>> getFutureLocation(String locationName) async {
//     isLocationLoading.value = true;
//     final ApiResponse response = await _apiCommunication.doGetRequest(
//       apiEndPoint: 'global-search-location?search=$locationName',
//       responseDataKey: ApiConstant.FULL_RESPONSE,
//     );
//     isLocationLoading.value = false;
//     if (response.isSuccessful) {
//       locationList.value =
//           (((response.data as Map<String, dynamic>)['results']) as List)
//               .map((element) => AllLocation.fromJson(element))
//               .toList();
//
//       update();
//     } else {
//       debugPrint('');
//     }
//     return locationList.value;
//   }
//
//   //-------------------------------------- declined-invitation ----------------------------//
//
//   Future<void> declinedPage(
//       String invitationId,
//       ) async {
//     final ApiResponse response = await pageRepository.actionOnPageInvite(
//       invitationId: invitationId,
//       acceptInvite: false,
//     );
//     if (response.isSuccessful) {
//       showSuccessSnackkbar(message: 'Pages Invitation declined successfully');
//       getInvites();
//     } else {
//       debugPrint('');
//     }
//   }
//
//   //-------------------------------------- accept-invitation ----------------------------//
//
//   Future<void> acceptPage(String invitationId, String pageId) async {
//     final ApiResponse response = await pageRepository.actionOnPageInvite(
//       invitationId: invitationId,
//       acceptInvite: true,
//     );
//     if (response.isSuccessful) {
//       showSuccessSnackkbar(message: 'Pages Invitation accepted successfully');
//       getInvites();
//     } else {
//       debugPrint('');
//     }
//   }
//
//   //-------------------------------------- follow-page ----------------------------//
//
//   Future<void> followPage(String pageId) async {
//     final ApiResponse response = await pageRepository.followPage(pageId);
//     if (response.isSuccessful) {
//       allpagesList.value.clear();
//       getAllPages();
//       getFollowedPages(forceFetch: true);
//       showSuccessSnackkbar(message: 'Already followed the page');
//     } else {
//       debugPrint('');
//     }
//   }
//
//   //==========================================Send Friend invites =====================================//
//
//   Future sendFriendInvitation(
//       String pageId,
//       ) async {
//     isLoadingFriendList.value = true;
//     ApiResponse apiResponse =
//     await pageRepository.sendPageFollowInviteToFriends(
//         pageId: pageId,
//         userIds: selectedPageInvitationList.value
//             .map((model) => model.friend?.id)
//             .toList());
//
//     if (apiResponse.isSuccessful) {
//       showSuccessSnackkbar(message: 'page Invitation Send successfully');
//     }
//     isLoadingUserPages.value = false;
//   }
//
//   //=========================================== For Scrolling List View
//
//   Future<void> _scrollListenerForDiscover() async {
//     if (discoverPageScrollController.position.pixels ==
//         discoverPageScrollController.position.maxScrollExtent) {
//       debugPrint('::::::::::::::Scroll');
//       if (skip < pageCount.value) {
//         skip += 12;
//         // allpagesList.value.clear();
//         debugPrint(
//             '----------------------------------------------------------------');
//         debugPrint(skip.toString());
//         await getAllPages();
//       }
//     }
//   }
//
//   Future<void> _scrollListenerForMyPages() async {
//     if (myPageScrollController.position.pixels ==
//         myPageScrollController.position.maxScrollExtent) {
//       debugPrint('::::::::::::::Scroll');
//       if (skip * limit < pageCount.value) {
//         skip += 1;
//         myPagesList.value.clear();
//         await getMyPages();
//       }
//     }
//   }
//
//   Future<void> _scrollListenerForFollowedPages() async {
//     if (followedPageScrollController.position.pixels ==
//         followedPageScrollController.position.maxScrollExtent) {
//       debugPrint('::::::::::::::Scroll');
//       if (skip * limit < pageCount.value) {
//         skip += 1;
//         followedPageList.value.clear();
//         await getFollowedPages();
//       }
//     }
//   }
//
//   Future<void> _scrollListenerForInvitePages() async {
//     if (invitePageScrollController.position.pixels ==
//         invitePageScrollController.position.maxScrollExtent) {
//       debugPrint('::::::::::::::Scroll');
//       if (skip * limit < pageCount.value) {
//         skip += 1;
//         invitesPageList.value.clear();
//         await getInvites();
//       }
//     }
//   }
//
//   @override
//   void onInit() {
//     _apiCommunication = ApiCommunication();
//     loginCredential = LoginCredential();
//     nameController = TextEditingController();
//     bioController = TextEditingController();
//     zipCodeController = TextEditingController();
//     descriptionController = TextEditingController();
//     discoverPageScrollController = ScrollController();
//     myPageScrollController = ScrollController();
//     followedPageScrollController = ScrollController();
//     invitePageScrollController = ScrollController();
//     myPagesModel = Get.arguments;
//
//     //! API CALL COMMENTED OUT ----------------------
//     // getAllPages();
//
//     //? API CALL COMMENTED OUT ---------------------- > MOVED TO ON CLICK ACTION FROM PAGE
//     // getFollowedPages();
//     // getInvites();
//     // getMyPages();
//
//     super.onInit();
//   }
//
//   @override
//   void onReady() {
//     discoverPageScrollController.addListener(_scrollListenerForDiscover);
//     myPageScrollController.addListener(_scrollListenerForMyPages);
//     followedPageScrollController.addListener(_scrollListenerForFollowedPages);
//     invitePageScrollController.addListener(_scrollListenerForInvitePages);
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     _apiCommunication.endConnection();
//     debounce?.cancel();
//     discoverPageScrollController.dispose();
//     myPageScrollController.dispose();
//     followedPageScrollController.dispose();
//     invitePageScrollController.dispose();
//     pageCount.value = 0;
//     super.onClose();
//   }
//
//   void increment() => count.value++;
// }
