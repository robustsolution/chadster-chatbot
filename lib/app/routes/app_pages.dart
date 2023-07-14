import 'package:get/get.dart';

import '../modules/Ai_Response/bindings/ai_response_binding.dart';
import '../modules/Ai_Response/views/ai_response_view.dart';
import '../modules/about_app_screen/bindings/about_app_screen_binding.dart';
import '../modules/about_app_screen/views/about_app_screen_view.dart';
import '../modules/ai_credit/views/ai_screen_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/explore_detail/bindings/explore_detail_binding.dart';
import '../modules/explore_detail/views/explore_detail_view.dart';
import '../modules/explore_response/bindings/explore_response_binding.dart';
import '../modules/explore_response/views/explore_response_view.dart';
import '../modules/favorite_task/bindings/favorite_task_binding.dart';
import '../modules/favorite_task/views/favorite_task_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_screen/bindings/home_screen_binding.dart';
import '../modules/home_screen/views/home_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/main_dashboard/bindings/main_dashboard_binding.dart';
import '../modules/main_dashboard/views/main_dashboard_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/privacy_policy_screen/bindings/privacy_policy_screen_binding.dart';
import '../modules/privacy_policy_screen/views/privacy_policy_screen_view.dart';
import '../modules/question_screen/bindings/question_screen_binding.dart';
import '../modules/question_screen/views/question_screen_view.dart';
import '../modules/save_screen/bindings/save_screen_binding.dart';
import '../modules/save_screen/views/save_screen_view.dart';
import '../modules/setting_screen/bindings/setting_screen_binding.dart';
import '../modules/setting_screen/views/setting_screen_view.dart';
import '../modules/store_screen/bindings/store_screen_binding.dart';
import '../modules/store_screen/views/store_screen_view.dart';
import '../modules/support_screen/bindings/support_screen_binding.dart';
import '../modules/support_screen/views/support_screen_view.dart';
import '../modules/tasks_screen/bindings/tasks_screen_binding.dart';
import '../modules/tasks_screen/views/tasks_screen_view.dart';
import '../modules/trail/bindings/trail_binding.dart';
import '../modules/trail/views/trail_view.dart';
import '../modules/webview/bindings/webview_bindings.dart';
import '../modules/webview/view/webview.dart';

// import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart';
// import '../modules/main_dashboard/bindings/main_dashboard_binding.dart';
// import '../modules/main_dashboard/views/main_dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_DASHBOARD,
      page: () => MainDashboardView(),
      binding: MainDashboardBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION_TEST,
      page: () => StoreScreenView(),
      // binding: MainDashboardBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.HOME_SCREEN,
      page: () => HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.AI_CREDIT,
      page: () => AICreditView(),
    ),
    GetPage(
      name: _Paths.STORE_SCREEN,
      page: () => StoreScreenView(),
      binding: StoreScreenBinding(),
    ),
    GetPage(
      name: _Paths.SAVE_SCREEN,
      page: () => SaveScreenView(),
      binding: SaveScreenBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_SCREEN,
      page: () => SettingScreenView(),
      binding: SettingScreenBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION_SCREEN,
      page: () => QuestionScreenView(),
      binding: QuestionScreenBinding(),
    ),
    GetPage(
      name: _Paths.AI_RESPONSE,
      page: () => AiResponseView(),
      binding: AiResponseBinding(),
    ),
    GetPage(
      name: _Paths.TASKS_SCREEN,
      page: () => TasksScreenView(),
      binding: TasksScreenBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP_SCREEN,
      page: () => AboutAppScreenView(),
      binding: AboutAppScreenBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY_SCREEN,
      page: () => PrivacyPolicyScreenView(),
      binding: PrivacyPolicyScreenBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT_SCREEN,
      page: () => SupportScreenView(),
      binding: SupportScreenBinding(),
    ),
    GetPage(
      name: _Paths.WEB_VIEW,
      page: () => WebViewScreen(),
      binding: WebViewScreenBining(),
    ),
    GetPage(
      name: _Paths.TRAIL,
      page: () => const TrailView(),
      binding: TrailBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE_DETAIL,
      page: () => const ExploreDetailView(),
      binding: ExploreDetailBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE_RESPONSE,
      page: () => const ExploreResponseView(),
      binding: ExploreResponseBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE_TASK,
      page: () => const FavoriteTaskView(),
      binding: FavoriteTaskBinding(),
    ),
  ];
}
