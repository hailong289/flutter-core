import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 200)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
