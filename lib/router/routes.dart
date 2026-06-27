abstract final class AppRoutes {
  static const home = '/';
  static const items = '/items';
  static const settings = '/settings';

  static String itemDetail(int id) => '/items/$id';
}
