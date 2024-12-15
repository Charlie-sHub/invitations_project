import 'package:auto_route/auto_route.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    // The Splash page might be needed for the mobile app versions
    // AutoRoute(page: SplashRoute.page),
    AutoRoute(page: HomeRoute.page, path: '/'),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: AccountRoute.page),
    AutoRoute(page: CartRoute.page),
    AutoRoute(page: InvitationEditionRoute.page),
    AutoRoute(page: InvitationViewRoute.page, path: '/invitations/:id'),
  ];
}
