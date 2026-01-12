import 'package:auto_route/auto_route.dart';
import '../../data/datasources/local/sp_manager.dart';
import '../../core/utils/log_util.dart';

/// Route guard for authentication
/// 
/// Checks if user is authenticated before allowing navigation to protected routes
/// Redirects to login page if not authenticated
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    try {
      final token = await SPManager.getToken();

      if (token != null && token.isNotEmpty) {
        // User is authenticated, proceed with navigation
        LogUtil.d('AuthGuard: User authenticated, allowing navigation');
        resolver.next(true);
      } else {
        // User is not authenticated, redirect to login
        LogUtil.w('AuthGuard: User not authenticated, redirecting to login');
        
        // For now, just block navigation since we don't have a login page yet
        // In production, this would redirect to LoginRoute
        resolver.next(false);
        
        // TODO: Implement login page and redirect
        // resolver.redirect(
        //   LoginRoute(
        //     onResult: (success) {
        //       if (success) {
        //         resolver.next(true);
        //       } else {
        //         resolver.next(false);
        //       }
        //     },
        //   ),
        // );
      }
    } catch (e) {
      LogUtil.e('AuthGuard: Error checking authentication', e);
      resolver.next(false);
    }
  }
}
