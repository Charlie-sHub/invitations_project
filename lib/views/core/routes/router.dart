import 'package:auto_route/auto_route.dart';
import 'package:invitations_project/views/core/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, path: '/'),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: CartRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: InvitationEditionRoute.page),
    AutoRoute(page: InvitationViewRoute.page, path: '/invitations/:id'),
  ];
}
