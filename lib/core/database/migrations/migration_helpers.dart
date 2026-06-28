import 'package:drift/drift.dart';

Future<Set<String>> tableColumns(GeneratedDatabase db, String tableName) async {
  final columns = await db
      .customSelect("SELECT name FROM pragma_table_info('$tableName')")
      .get();
  return columns.map((row) => row.read<String>('name')).toSet();
}

Future<bool> tableHasColumn(
  GeneratedDatabase db,
  String tableName,
  String columnName,
) async {
  final columns = await tableColumns(db, tableName);
  return columns.contains(columnName);
}
