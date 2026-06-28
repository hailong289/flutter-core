abstract final class AppRoutes {
  static const home = '/';
  static const items = '/items';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
  static const error = '/error';

  static String itemDetail(int id) => '/items/$id';
}
