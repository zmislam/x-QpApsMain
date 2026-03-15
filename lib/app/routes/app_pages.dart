import 'package:get/get.dart';

import '../modules/NAVIGATION_MENUS/account_switch_page/bindings/account_switch_page_binding.dart';
import '../modules/NAVIGATION_MENUS/account_switch_page/views/account_switch_page_view.dart';
import '../modules/advance_search/bindings/advance_search_binding.dart';
import '../modules/advance_search/views/advance_search_view.dart';
import '../modules/birthdays/bindings/birthdays_binding.dart';
import '../modules/birthdays/views/birthdays_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/bindings/create_event_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/events/views/create_event_view.dart';
import '../modules/NAVIGATION_MENUS/feeds/bindings/feeds_binding.dart';
import '../modules/NAVIGATION_MENUS/feeds/views/feeds_view.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/suggested_reels/bindings/suggested_reels_binding.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/suggested_reels/views/suggested_reels_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/bindings/buyer_panel_dashboard_binding.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/views/buyer_panel_dashboard_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/views/complain_list_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/views/order_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/views/return_refund_list.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_dashboard/views/review_list_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_order_details/bindings/buyer_order_details_binding.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_order_details/views/buyer_order_details_view.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/bindings/buyer_return_refund_binding.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/buyer_refund_and_return_details/bindings/buyer_refund_details_binding.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/buyer_refund_and_return_details/views/buyer_return_refund_details.dart';
import '../modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/views/buyer_return_refund_form_view.dart';
import '../modules/NAVIGATION_MENUS/explore/bindings/explore_binding.dart';
import '../modules/NAVIGATION_MENUS/explore/view/explore_view.dart';
import '../modules/NAVIGATION_MENUS/friend/bindings/friend_binding.dart';
import '../modules/NAVIGATION_MENUS/friend/views/friend_suggestion_view.dart';
import '../modules/NAVIGATION_MENUS/friend/views/friend_view.dart';
import '../modules/NAVIGATION_MENUS/friend/views/your_friends_view.dart';
import '../modules/NAVIGATION_MENUS/home/bindings/home_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/bindings/create_story_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/add_audio/bindings/add_audio_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/add_audio/views/add_audio_view.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_image_story/bindings/create_image_story_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_image_story/views/create_image_story_view.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_multi_image_story/bindings/create_multi_image_story_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_multi_image_story/views/create_multi_image_story_view.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_text_story/bindings/create_text_story_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/create_text_story/views/create_text_story_view.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/story_settings/bindings/story_settings_binding.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/sub_menus/story_settings/views/story_settings_view.dart';
import '../modules/NAVIGATION_MENUS/home/create_story/views/create_story_view.dart';
import '../modules/NAVIGATION_MENUS/home/views/home_view.dart';
import '../modules/NAVIGATION_MENUS/live_reels/bindings/live_reels_bindings.dart';
import '../modules/NAVIGATION_MENUS/live_reels/views/live_reels_view.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_cart/bindings/cart_binding.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_cart/views/cart_view.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_products/bindings/marketplace_binding.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_products/views/marketplace_view.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_wishlist/bindings/marketplace_wishlist_binding.dart';
import '../modules/NAVIGATION_MENUS/marketplace/marketplace_wishlist/views/marketplace_wishlist_view.dart';
import '../modules/NAVIGATION_MENUS/marketplace/product_details/bindings/product_details_binding.dart';
import '../modules/NAVIGATION_MENUS/marketplace/product_details/views/product_details_view.dart';
import '../modules/NAVIGATION_MENUS/marketplace/store_based_products/bindings/store_products_binding.dart';
import '../modules/NAVIGATION_MENUS/marketplace/store_based_products/views/store_products_view.dart';
import '../modules/NAVIGATION_MENUS/notification/bindings/notification_binding.dart';
import '../modules/NAVIGATION_MENUS/notification/views/notification_view.dart';
import '../modules/NAVIGATION_MENUS/other_reels_video/bindings/other_reels_video_bindings.dart';
import '../modules/NAVIGATION_MENUS/other_reels_video/views/other_reels_video_view.dart';
import '../modules/NAVIGATION_MENUS/reels/bindings/reels_binding.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/boost_reels/bindings/boost_reels_bindings.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/boost_reels/views/boost_reels_view.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/create_reels/bindings/create_reels_binding.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/create_reels/views/create_reels_view.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/edit_reels/bindings/edit_reels_bindings.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/edit_reels/views/edit_reels_view.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/reels_description/bindings/reels_description_binding.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/reels_description/views/reels_description_view.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/reels_setting/bindings/reels_setting_binding.dart';
import '../modules/NAVIGATION_MENUS/reels/sub_menu/reels_setting/views/reels_setting_view.dart';
import '../modules/NAVIGATION_MENUS/reels/views/reels_view.dart';
import '../modules/NAVIGATION_MENUS/seller_panel/bindings/seller_panel_dashboard_binding.dart';
import '../modules/NAVIGATION_MENUS/seller_panel/views/seller_panel_dashboard_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/bindings/user_menu_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/create_group/bindings/create_group_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/create_group/views/create_group_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/discover_groups/bindings/discover_groups_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/discover_groups/views/discover_groups_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/bindings/group_settings_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_add_admin_moderator.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_admins_moderators_list_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_basic_information.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_privacy.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_settings_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_admin/views/group_transfer_ownership.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_feed/bindings/group_feed_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_feed/views/group_feed_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_file_upload/bindings/group_file_upload_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_file_upload/views/group_file_upload_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_members_admins_moderators/bindings/group_members_admins_moderators_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_members_admins_moderators/views/group_members_admins_moderators_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/bindings/group_profile_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_albums_gallery/bindings/group_albums_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_albums_gallery/views/group_albums_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_photos_gallery/bindings/group_photos_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_photos_gallery/views/group_photos_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_videos_gallery/bindings/group_videos_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/group_profile_all_media/group_videos_gallery/views/group_videos_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/views/group_member_join_request_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/views/group_profile_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/invite_groups/bindings/invite_groups_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/invite_groups/views/invite_groups_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/joined_groups/bindings/joined_groups_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/joined_groups/views/joined_groups_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/my_groups/bindings/my_groups_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/my_groups/views/my_groups_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/admin_page/binding/admin_page_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/admin_page/view/admin_page_profile_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/bindings/page_profile_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/views/page_profile_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_settings/binding/page_settings_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_settings/view/page_setting.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/bindings/pages_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/views/pages_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/bookmarks/bindings/bookmarks_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/bookmarks/views/bookmarks_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/help_support/bindings/help_support_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/help_support/views/help_support_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/bindings/profile_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add website/bindings/add_website_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add website/views/add_website_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_contact/bindings/add_contact_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_contact/views/add_contact_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_contact/views/otp_verification.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_education/bindings/add_education_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_education/views/add_education_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_language/bindings/add_language_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_language/views/add_language_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_work_place/bindings/add_work_place_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/add_work_place/views/add_work_place_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_about_yourself/bindings/add_edit_about_yourself_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_about_yourself/views/add_edit_about_yourself_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_bio/bindings/add_edit_bio_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_bio/views/add_edit_bio_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_birth_date/bindings/edit_birth_date_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_birth_date/views/edit_birth_date_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_gender/bindings/edit_gender_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_gender/views/edit_gender_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_nickname/bindings/edit_nickname_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_nickname/views/edit_nickname_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_places_lived/bindings/edit_places_lived_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_places_lived/views/edit_places_lived_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_relationship/bindings/edit_relationship_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/add_about/edit_relationship/views/edit_relationship_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/bindings/about_bindings.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/views/about_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/albums_gallery/bindings/albums_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/albums_gallery/views/albums_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/my_profile_friends/bindings/my_profile_friends_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/my_profile_friends/views/my_profile_friends_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/photos_gallery/bindings/photos_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/photos_gallery/views/photos_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/videos_gallery/bindings/videos_gallery_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/videos_gallery/views/videos_gallery_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/views/friend_list.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/views/profile_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/bindings/wallet_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet/views/wallet_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/minted_events/bindings/minted_events_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/minted_events/views/minted_events_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_add_balance/bindings/qp_wallet_add_balance_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_add_balance/views/qp_wallet_add_balance_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_billing/bindings/qp_wallet_billing_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_billing/views/qp_wallet_billing_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_dashboard/bindings/qp_wallet_dashboard_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_dashboard/views/qp_wallet_dashboard_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_payment_settings/bindings/qp_wallet_payment_settings_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_payment_settings/views/qp_wallet_payment_settings_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_send_money/bindings/qp_wallet_send_money_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_send_money/views/qp_wallet_send_money_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_transaction_history/bindings/qp_wallet_transaction_history_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_transaction_history/views/qp_wallet_transaction_history_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_transaction_view/bindings/qp_wallet_transaction_view_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_transaction_view/views/qp_wallet_transaction_view_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_withdraw/bindings/qp_wallet_withdraw_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/qp_wallet_withdraw/views/qp_wallet_withdraw_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/wallet_connect/bindings/wallet_connect_binding.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/wallet_module/wallet_connect/views/wallet_connect_view.dart';
import '../modules/NAVIGATION_MENUS/user_menu/views/user_menu_view.dart';
import '../modules/ad_manager/ads_campaign_creation/bindings/ads_campaign_creation_binding.dart';
import '../modules/ad_manager/ads_campaign_creation/views/ads_campaign_creation_view.dart';
import '../modules/ad_manager/ads_campaign_creation/views/p2_ads_campaign_creation_location_view.dart';
import '../modules/ad_manager/ads_campaign_creation/views/p3_ads_campaign_creation_asset_view.dart';
import '../modules/ad_manager/ads_campaign_creation/views/p4_ads_campaign_creation_confirm_view.dart';
import '../modules/ad_manager/ads_campaign_details/bindings/ads_campaign_details_binding.dart';
import '../modules/ad_manager/ads_campaign_details/views/ads_campaign_details_view.dart';
import '../modules/ad_manager/ads_campaign_extend_page/bindings/ads_campaign_extend_page_binding.dart';
import '../modules/ad_manager/ads_campaign_extend_page/views/ads_campaign_extend_page_view.dart';
import '../modules/ad_manager/ads_campaign_home/bindings/ads_campaign_home_binding.dart';
import '../modules/ad_manager/ads_campaign_home/views/ads_campaign_home_view.dart';
import '../modules/ad_manager/all_campaign/bindings/all_campaign_binding.dart';
import '../modules/ad_manager/all_campaign/views/all_campaign_view.dart';
import '../modules/audience_live_stream_preview/bindings/audience_live_stream_preview_binding.dart';
import '../modules/audience_live_stream_preview/views/audience_live_stream_preview_view.dart';
import '../modules/auth/forget_password/bindings/forget_pass_binding.dart';
import '../modules/auth/forget_password/views/forget_password_otp_view.dart';
import '../modules/auth/forget_password/views/forget_password_view.dart';
import '../modules/auth/forget_password/views/set_forgetpassword_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/birthday_view.dart';
import '../modules/auth/signup/views/email_view.dart';
import '../modules/auth/signup/views/gender_view.dart';
import '../modules/auth/signup/views/name_view.dart';
import '../modules/auth/signup/views/number_view.dart';
import '../modules/auth/signup/views/otp_verification.dart';
import '../modules/auth/signup/views/password_view.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/auth/splash/bindings/splash_binding.dart';
import '../modules/auth/splash/views/splash_view.dart';
import '../modules/boost_post/bindings/boost_post_binding.dart';
import '../modules/boost_post/views/boost_post_view.dart';
import '../modules/custom_camera/bindings/custom_camera_binding.dart';
import '../modules/custom_camera/views/custom_camera_view.dart';
import '../modules/earnDashboard/bindings/earn_dashboard_binding.dart';
import '../modules/earnDashboard/views/earn_dashboard_view.dart';
import '../modules/edit_post/bindings/edit_post_binding.dart';
import '../modules/edit_post/views/edit_post_view.dart';
import '../modules/global_search/bindings/global_search_binding.dart';
import '../modules/global_search/views/global_search_view.dart';
import '../modules/go_live/bindings/go_live_binding.dart';
import '../modules/go_live/views/go_live_view.dart';
import '../modules/live_stream/bindings/live_stream_binding.dart';
import '../modules/live_stream/views/live_stream_view.dart';
import '../modules/notification_post/bindings/notification_binding.dart';
import '../modules/notification_post/view/notification_post.dart';
import '../modules/shared/components/comment_reactions/bindings/comment_reactions_binding.dart';
import '../modules/shared/components/comment_reactions/views/comment_reactions_view.dart';
import '../modules/shared/components/comment_replay_reactions/bindings/comment_replay_reactions_binding.dart';
import '../modules/shared/components/comment_replay_reactions/views/comment_replay_reactions_view.dart';
import '../modules/shared/components/post_reactions/bindings/post_reactions_binding.dart';
import '../modules/shared/components/post_reactions/views/post_reactions_view.dart';
import '../modules/shared/components/reels_comment_reactions/bindings/reels_comment_reactions_binding.dart';
import '../modules/shared/components/reels_comment_reactions/views/reels_comment_reactions_view.dart';
import '../modules/shared/components/reels_comment_reply_reactions/bindings/reels_comment_reply_reactions_binding.dart';
import '../modules/shared/components/reels_comment_reply_reactions/views/reels_comment_reply_reactions_view.dart';
import '../modules/shared/components/reels_reactions/bindings/reels_reactions_binding.dart';
import '../modules/shared/components/reels_reactions/views/reels_reactions_view.dart';
import '../modules/shared/modules/create_group_post/bindings/create_group_post_bindings.dart';
import '../modules/shared/modules/create_group_post/view/create_group_post_view.dart';
import '../modules/shared/modules/create_page_post/bindings/create_page_post_bindings.dart';
import '../modules/shared/modules/create_page_post/view/create_page_post_view.dart';
import '../modules/shared/modules/create_post/bindings/create_post_bindings.dart';
import '../modules/shared/modules/create_post/view/check_in.dart';
import '../modules/shared/modules/create_post/view/create_post_view.dart';
import '../modules/shared/modules/create_post/view/event_page.dart';
import '../modules/shared/modules/create_post/view/feelings.dart';
import '../modules/shared/modules/create_post/view/gif_page.dart';
import '../modules/shared/modules/create_post/view/tag_people.dart';
import '../modules/shared/modules/detail_post/bindings/detail_post_binding.dart';
import '../modules/shared/modules/detail_post/views/detail_post_view.dart';
import '../modules/shared/modules/edit_history/bindings/post_history_bindings.dart';
import '../modules/shared/modules/edit_history/view/post_history_view.dart';
import '../modules/shared/modules/edit_post_comment/bindings/edit_post_comment_binding.dart';
import '../modules/shared/modules/edit_post_comment/views/edit_post_comment_view.dart';
import '../modules/shared/modules/edit_reels_comment/bindings/edit_reels_comment_binding.dart';
import '../modules/shared/modules/edit_reels_comment/edit_reels_reply_comment/bindings/edit_reels_reply_comment_binding.dart';
import '../modules/shared/modules/edit_reels_comment/edit_reels_reply_comment/views/edit_reels_reply_comment_view.dart';
import '../modules/shared/modules/edit_reels_comment/views/edit_reels_comment_view.dart';
import '../modules/shared/modules/edit_reply_post_comment/bindings/edit_reply_post_comment_binding.dart';
import '../modules/shared/modules/edit_reply_post_comment/views/edit_reply_post_comment_view.dart';
import '../modules/shared/modules/other_profile_view/bindings/other_profile_binding.dart';
import '../modules/shared/modules/other_profile_view/views/other_photos_gallery/binding/other_photos_gallery_bindings.dart';
import '../modules/shared/modules/other_profile_view/views/other_photos_gallery/view/other_photos_gallery_view.dart';
import '../modules/shared/modules/other_profile_view/views/other_profile_detail_view.dart';
import '../modules/shared/modules/other_profile_view/views/other_profile_friend_list_view.dart';
import '../modules/shared/modules/other_profile_view/views/other_profile_view.dart';
import '../modules/shared/modules/other_profile_view/views/others_album_gallery/binding/others_album_gallery_binding.dart';
import '../modules/shared/modules/other_profile_view/views/others_album_gallery/view/other_album_gallery_view.dart';
import '../modules/shared/profile_image_silder/bindings/profile_image_silder_binding.dart';
import '../modules/shared/profile_image_silder/views/profile_image_silder_view.dart';
import '../modules/tab_view/bindings/tab_view_bindings.dart';
import '../modules/tab_view/views/tab_view.dart';
import 'package:quantum_possibilities_flutter/app/utils/Localization/lib/app/modules/changeLanguage/bindings/change_language_binding.dart';
import 'package:quantum_possibilities_flutter/app/utils/Localization/lib/app/modules/changeLanguage/views/change_language_view.dart';
import '../modules/NAVIGATION_MENUS/feed_preferences/bindings/feed_preferences_binding.dart';
import '../modules/NAVIGATION_MENUS/feed_preferences/views/feed_preferences_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASS,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASS_OTP,
      page: () => ForgetPasswordOtpView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASS_SET,
      page: () => SetforgetpassView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NAME,
      page: () => NameView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => OtpView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.BIRTHDAY,
      page: () => BirthdayView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.GENDER,
      page: () => GenderView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.EMAIL,
      page: () => EmailView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.NUMBER,
      page: () => NumberView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD,
      page: () => PasswordView(),
      binding: SignupBinding(),
    ),

    GetPage(
      name: _Paths.REELS,
      page: () => const ReelsView(),
      binding: ReelsBinding(),
    ),

    GetPage(
      name: _Paths.BOOST_REELS,
      page: () => const BoostReelsView(),
      binding: BoostReelsBinding(),
    ),
    GetPage(
      name: _Paths.OTHER_USER_VIDEO,
      page: () => const OtherReelsVideoView(),
      binding: OtherReelsVideoBinding(),
    ),
    GetPage(
        name: _Paths.EXPLORE,
        page: () => const ExploreView(),
        binding: ExploreBinding()),
    GetPage(
      name: _Paths.FRIEND,
      page: () => const FriendView(),
      binding: FriendBinding(),
    ),
    GetPage(
      name: _Paths.FRIEND_SUGGESTION,
      page: () => const FriendSuggestionView(),
      binding: FriendBinding(),
    ),
    GetPage(
      name: _Paths.YOUR_FRIENDS,
      page: () => const YourFriendsView(),
      binding: FriendBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.MARKETPLACE,
      page: () => const MarketplaceView(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TAB,
      page: () => const TabView(),
      binding: TabViewBindings(),
    ),
    GetPage(
      name: _Paths.USER_MENU,
      page: () => const UserMenuView(),
      binding: UserMenuBinding(),
      children: [
        GetPage(
          name: _Paths.QP_WALLET_DASHBOARD,
          page: () => const QpWalletDashboardView(),
          binding: QpWalletDashboardBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_SEND_MONEY,
          page: () => const QpWalletSendMoneyView(),
          binding: QpWalletSendMoneyBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_PAYMENT_SETTINGS,
          page: () => const QpWalletPaymentSettingsView(),
          binding: QpWalletPaymentSettingsBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_BILLING,
          page: () => const QpWalletBillingView(),
          binding: QpWalletBillingBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_WITHDRAW,
          page: () => const QpWalletWithdrawView(),
          binding: QpWalletWithdrawBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_TRANSACTION_HISTORY,
          page: () => const QpWalletTransactionHistoryView(),
          binding: QpWalletTransactionHistoryBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_ADD_BALANCE,
          page: () => const QpWalletAddBalanceView(),
          binding: QpWalletAddBalanceBinding(),
        ),
        GetPage(
          name: _Paths.WALLET_CONNECT,
          page: () => const WalletConnectView(),
          binding: WalletConnectBinding(),
        ),
        GetPage(
          name: _Paths.MINTED_EVENTS,
          page: () => const MintedEventsView(),
          binding: MintedEventsBinding(),
        ),
        GetPage(
          name: _Paths.QP_WALLET_TRANSACTION_VIEW,
          page: () => const QpWalletTransactionViewView(),
          binding: QpWalletTransactionViewBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.CREAT_POST,
      page: () => const CreatePostView(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.CREATE_GROUP_POST,
      page: () => const CreateGroupPostView(),
      binding: CreateGroupPostBindings(),
    ),
    GetPage(
      name: _Paths.TAG_PEOPLE,
      page: () => const TagPeople(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.FEELINGS,
      page: () => const Feelings(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.CHECKIN,
      page: () => const CheckIn(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.GIF,
      page: () => const GifPage(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () => const EventPage(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: _Paths.REACTIONS,
      page: () => const ReactionsView(),
      binding: ReactionsBinding(),
      opaque: false,
      showCupertinoParallax: false,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.CREATE_STORY,
      page: () => const CreateStoryView(),
      binding: CreateStoryBinding(),
    ),
    GetPage(
      name: _Paths.OTHERS_PROFILE,
      page: () => const OtherProfileView(),
      binding: OtherProfileBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_TEXT_STORY,
      page: () => const CreateTextStoryView(),
      binding: CreateTextStoryBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_IMAGE_STORY,
      page: () => const CreateImageStoryView(),
      binding: CreateImageStoryBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.OTHER_PROFILA_DETAIL,
      page: () => const OtherProfileDetailView(),
      binding: OtherProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_POST,
      page: () => const EditPostView(),
      binding: EditPostBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_FRIEND_LIST,
      page: () => const FriendList(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_POST,
      page: () => const DetailPostView(),
      binding: DetailPostBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_POST_COMMENT,
      page: () => const EditPostCommentView(),
      binding: EditPostCommentBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_REPLY_POST_COMMENT,
      page: () => const EditReplyPostCommentView(),
      binding: EditReplyPostCommentBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_REELS_COMMENT,
      page: () => const EditReelsCommentView(),
      binding: EditReelsCommentBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_REELS_REPLY_COMMENT,
      page: () => const EditReelsReplyCommentView(),
      binding: EditReelsReplyCommentBinding(),
    ),
    // GetPage(
    //   name: _Paths.STORY_REACTION,
    //   page: () => StoryReactionView(),
    //   binding: StoryReactionBinding(),
    // ),
    GetPage(
      name: _Paths.EDIT_GENDER,
      page: () => const EditGenderView(),
      binding: EditGenderBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_POST,
      page: () => const NotificationPost(),
      binding: NotificationBindings(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE_FRIENDS,
      page: () => const MyProfileFriendsView(),
      binding: MyProfileFriendsBinding(),
    ),
    GetPage(
      name: _Paths.COMMENT_REACTIONS,
      page: () => const CommentReactionsView(),
      binding: CommentReactionsBinding(),
    ),
    GetPage(
      name: _Paths.COMMENT_REPLAY_REACTIONS,
      page: () => const CommentReplayReactionsView(),
      binding: CommentReplayReactionsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_WORK_PLACE,
      page: () => const AddWorkPlaceView(),
      binding: AddWorkPlaceBinding(),
    ),
    // GetPage(
    //   name: _Paths.EDIT_WORK_PLACE,
    //   page: () => const EditWorkPlaceView(),
    //   binding: AddWorkPlaceBinding(),
    // ),
    GetPage(
      name: _Paths.ADD_EDUCATION,
      page: () => const AddEducationView(),
      binding: AddEducationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CONTACT,
      page: () => const AddContactView(),
      binding: AddContactBinding(),
    ),
    GetPage(
      name: _Paths.OTP_CONTACT,
      page: () => const OtpForContactView(),
      binding: AddContactBinding(),
    ),
    GetPage(
      name: _Paths.ADD_WEBSITE,
      page: () => const AddWebsiteView(),
      binding: AddWebsiteBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BIO,
      page: () => const AddYourBioView(),
      binding: AddYourBioBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ABOUTYOURSELF,
      page: () => const AddAboutYourselfView(),
      binding: AddAboutYourselfBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PLACESLIVED,
      page: () => const EditPlacesLivedView(),
      binding: EditPlacesLivedBinding(),
    ),
    GetPage(
      name: _Paths.ADD_LANGUAGE,
      page: () => const AddLanguageView(),
      binding: AddLanguageBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_NICKNAME,
      page: () => const EditNickNameView(),
      binding: EditNickNameBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_RELATIONSHIP,
      page: () => const EditRelationshipView(),
      binding: EditRelationshipBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BIRTH_DATE,
      page: () => const EditBirthDateView(),
      binding: EditBirthDateBinding(),
    ),
    GetPage(
      name: _Paths.PAGES,
      page: () => const PagesView(),
      binding: PagesBinding(),
    ),
    GetPage(
      name: _Paths.BOOKMARKS,
      page: () => BookmarksView(),
      binding: BookmarksBinding(),
    ),
    GetPage(
      name: _Paths.OTHER_FRIEND_LIST,
      page: () => const OtherProfileFriendsView(),
      binding: OtherProfileBinding(),
    ),
    GetPage(
      name: _Paths.PHOTOS_GALLERY,
      page: () => const PhotosGalleryView(),
      binding: PhotosGalleryBinding(),
    ),
    GetPage(
      name: _Paths.ALBUMS_GALLERY,
      page: () => const AlbumsGalleryView(),
      binding: AlbumsGalleryBinding(),
    ),
    GetPage(
      name: _Paths.VIDEOS_GALLERY,
      page: () => const VideosGalleryView(),
      binding: VideosGalleryBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_PHOTOS_GALLERY,
      page: () => const GroupPhotosGalleryView(),
      binding: GroupPhotosGalleryBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_ALBUMS_GALLERY,
      page: () => const GroupAlbumsGalleryView(),
      binding: GroupAlbumsGalleryBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_VIDEOS_GALLERY,
      page: () => const GroupVideosGalleryView(),
      binding: GroupVideosGalleryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_HISTORY,
      page: () => const PostHistoryView(),
      binding: PostHistoryBindings(),
    ),
    GetPage(
      name: _Paths.PROFILE_IMAGE_SILDER,
      page: () => const ProfileImageSilderView(),
      binding: ProfileImageSilderBinding(),
    ),
    GetPage(
      name: _Paths.OTHER_ALBUMS_GALLERY,
      page: () => const OtherAlbumGalleryView(),
      binding: OthersAlbumGalleryBinding(),
    ),
    GetPage(
      name: _Paths.OTHER_PHOTOS_GALLERY,
      page: () => const OtherPhotosGalleryView(),
      binding: OtherPhotosGalleryBindings(),
    ),
    GetPage(
      name: _Paths.CREATE_REELS,
      page: () => const CreateReelsView(),
      binding: CreateReelsBinding(),
    ),
    GetPage(
      name: _Paths.REELS_REACTIONS,
      page: () => const ReelsReactionsView(),
      binding: ReelsReactionsBinding(),
    ),
    GetPage(
      name: _Paths.REELS_COMMENT_REACTIONS,
      page: () => const ReelsCommentReactionsView(),
      binding: ReelsCommentReactionsBinding(),
    ),
    GetPage(
      name: _Paths.REELS_COMMENT_REPLY_REACTIONS,
      page: () => const ReelsCommentReplyReactionsView(),
      binding: ReelsCommentReplyReactionsBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_PROFILE,
      page: () => const PageProfileView(),
      binding: PageProfileBinding(),
    ),

    //////////////////////////All Groups ////////////////////////////////////
    GetPage(
      name: _Paths.GROUPS,
      page: () => const DiscoverGroupsView(),
      binding: DiscoverGroupsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_GROUP,
      page: () => const CreateGroupView(),
      binding: CreateGroupBinding(),
    ),
    GetPage(
      name: _Paths.JOINED_GROUPS,
      page: () => const JoinedGroupsView(),
      binding: JoinedGroupsBinding(),
    ),
    GetPage(
      name: _Paths.INVITE_GROUPS,
      page: () => const InviteGroupsView(),
      binding: InviteGroupsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_MEMBERS_ADMINS_MODERATORS,
      page: () => const GroupMembersAdminsModeratorsView(),
      binding: GroupMembersAdminsModeratorsBinding(),
    ),
    GetPage(
      name: _Paths.MY_GROUPS,
      page: () => const MyGroupsView(),
      binding: MyGroupsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_PROFILE,
      page: () => const GroupProfileView(),
      binding: GroupProfileBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_FEED,
      page: () => const GroupFeedView(),
      binding: GroupFeedBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_SETTING,
      page: () => const GroupSettingsView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_BASIC_INFO,
      page: () => const GroupBasicInformationView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_PRIVACY,
      page: () => const GroupPrivacyView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_GROUP_ADMIN_MODERATOR,
      page: () => const GroupAddAdminModeratorView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_TRANSFER_OWNERSHIP,
      page: () => const GroupTransferOwnerShipView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.LIST_GROUP_ADMIN_MODERATOR,
      page: () => const GroupAdminModeratorListView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_MEMBER_LIST,
      page: () => const GroupMemberJoinRequestView(),
      binding: GroupProfileBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_FILES_UPLOAD,
      page: () => const GroupFileUploadView(),
      binding: GroupFileUploadBinding(),
    ),
    ///////Page//////////
    GetPage(
      name: _Paths.ADMIN_PAGE,
      page: () => const AdminPageProfileView(),
      binding: AdminPageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PAGE_POST,
      page: () => const CreatePagePostView(),
      binding: CreatePagePostBinding(),
    ),
    GetPage(
      name: _Paths.FEELINGS,
      page: () => const Feelings(),
      binding: CreatePagePostBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_SETTING,
      page: () => const PageSetting(),
      binding: PageSettingsBinding(),
    ),
    GetPage(
      name: _Paths.HELP_SUPPORT,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.GLOBAL_SEARCH,
      page: () => GlobalSearchView(),
      binding: GlobalSearchBinding(),
    ),
    //==========================Seller Panel All Pages===================//
    GetPage(
      name: _Paths.SELLER_DASHBOARD,
      page: () => const SellerPanelDashboardView(),
      binding: SellerPanelDashboardBinding(),
    ),
    //==========================Buyer Panel All Pages===================//
    GetPage(
      name: _Paths.BUYER_DASHBOARD,
      page: () => const BuyerPanelDashboardView(),
      binding: BuyerPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_ORDER_DETAILS,
      page: () => const BuyerOrderDetailsView(),
      binding: BuyerOrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_ORDER_LIST,
      page: () => const BuyerOrderView(),
      binding: BuyerPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_REVIEW,
      page: () => BuyerReviewListView(),
      binding: BuyerPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_COMPLAINT,
      page: () => const BuyerComplaintListView(),
      binding: BuyerPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_RETURN_REFUND_LIST,
      page: () => const BuyerReturnRefundListView(),
      binding: BuyerPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_RETURN_REFUND_FORM,
      page: () => const BuyerReturnRefundFormView(),
      binding: BuyerReturnRefundBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_RETURN_REFUND_DETAILS,
      page: () => const ReturnRefundDetailsView(),
      binding: BuyerReturnRefundDetailsBinding(),
    ),
    //==========================Market Place Pages===================//
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CART_PAGE,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.WISHLIST_PAGE,
      page: () => const MarketplaceWishlistView(),
      binding: MarketplaceWishlistBinding(),
    ),
    GetPage(
      name: _Paths.STORE_PRODUCTS_PAGE,
      page: () => const StoreProductsView(),
      binding: StoreProductsBinding(),
    ),
    GetPage(
      name: _Paths.STORY_SETTINGS,
      page: () => const StorySettingsView(),
      binding: StorySettingsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_AUDIO,
      page: () => const AddAudioView(),
      binding: AddAudioBinding(),
    ),
    GetPage(
      name: _Paths.REELS_SETTING,
      page: () => const ReelsSettingView(),
      binding: ReelsSettingBinding(),
    ),
    GetPage(
      name: _Paths.REELS_DESCRIPTION,
      page: () => const ReelsDescriptionView(),
      binding: ReelsDescriptionBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOM_CAMERA,
      page: () => CustomCameraView(),
      binding: CustomCameraBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_MULTI_IMAGE_STORY,
      page: () => const CreateMultiImageStoryView(),
      binding: CreateMultiImageStoryBinding(),
    ),
    GetPage(
      name: _Paths.BOOST_POST,
      page: () => BoostPostView(),
      binding: BoostPostBinding(),
    ),
    GetPage(
      name: _Paths.LIVE_STREAM,
      page: () => const LiveStreamView(),
      binding: LiveStreamBinding(),
    ),
    GetPage(
      name: _Paths.GO_LIVE,
      page: () => const GoLiveView(),
      binding: GoLiveBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SWITCH_PAGE,
      page: () => const AccountSwitchPageView(),
      binding: AccountSwitchPageBinding(),
    ),
    GetPage(
      name: _Paths.AUDIENCE_LIVE_STREAM_PREVIEW,
      page: () => AudienceLiveStreamPreviewView(),
      binding: AudienceLiveStreamPreviewBinding(),
    ),
    GetPage(
      name: _Paths.LIVE_REELS,
      page: () => const LiveReelsView(),
      binding: LiveReelsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_REELS,
      page: () => const EditReelsView(),
      binding: EditReelsBindings(),
    ),
    GetPage(
      name: _Paths.ADS_CAMPAIGN_HOME,
      page: () => AdsCampaignHomeView(),
      binding: AdsCampaignHomeBinding(),
    ),
    GetPage(
      name: _Paths.ADS_CAMPAIGN_CREATION,
      page: () => AdsCampaignCreationView(),
      binding: AdsCampaignCreationBinding(),
    ),
    GetPage(
      name: _Paths.ADS_CAMPAIGN_CREATION_LOCATION,
      page: () => AdsCampaignCreationLocationView(),
      binding: AdsCampaignCreationBinding(),
    ),

    GetPage(
      name: _Paths.ADS_CAMPAIGN_CREATION_ASSETS,
      page: () => AdsCampaignCreationAssetView(),
      binding: AdsCampaignCreationBinding(),
    ),
    GetPage(
      name: _Paths.ADS_CAMPAIGN_CREATION_CONFIRM,
      page: () => AdsCampaignCreationConfirmView(),
      binding: AdsCampaignCreationBinding(),
    ),

    GetPage(
      name: _Paths.ADS_CAMPAIGN_DETAILS,
      page: () => AdsCampaignDetailsView(),
      binding: AdsCampaignDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ALL_CAMPAIGN,
      page: () => AllCampaignView(),
      binding: AllCampaignBinding(),
    ),
    GetPage(
      name: _Paths.ADS_CAMPAIGN_EXTEND_PAGE,
      page: () => const AdsCampaignExtendPageView(),
      binding: AdsCampaignExtendPageBinding(),
    ),
    GetPage(
      name: _Paths.EARN_DASHBOARD,
      page: () => EarnDashboardView(),
      binding: EarnDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_LANGUAGE,
      page: () =>  ChangeLanguageView(),
      binding: ChangeLanguageBinding(),
    ),
    GetPage(
      name: _Paths.FEED_PREFERENCES,
      page: () => const FeedPreferencesView(),
      binding: FeedPreferencesBinding(),
    ),
    GetPage(
      name: _Paths.SUGGESTED_REELS,
      page: () => const SuggestedReelsView(),
      binding: SuggestedReelsBinding(),
    ),
    GetPage(
      name: _Paths.FEEDS,
      page: () => const FeedsView(),
      binding: FeedsBinding(),
    ),
    GetPage(
      name: _Paths.ADVANCE_SEARCH,
      page: () => const AdvanceSearchView(),
      binding: AdvanceSearchBinding(),
    ),
    GetPage(
      name: _Paths.BIRTHDAYS,
      page: () => const BirthdaysView(),
      binding: BirthdaysBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => const EventsView(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EVENT,
      page: () => const CreateEventView(),
      binding: CreateEventBinding(),
    ),
  ];
}
