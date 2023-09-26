import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sql/db_helper.dart';

void main() {
  group('Dbhelper tests', () {
    late Dbhelper dbHelper;

    setUp(() async {
      databaseFactoryOrNull = null;

      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory for unit testing calls for SQFlite
      databaseFactory = databaseFactoryFfi;

      // Initialize databaseFactory
      dbHelper = Dbhelper();
      await dbHelper.deleteAllNotes();
    });

    tearDown(() async {
      // Close database connection
      await dbHelper.close();
    });

    test('Insert and select notes', () async {
      const title = 'Test note';
      const done = 0;

      await dbHelper.insertNotes(title, done);

      final notes = await dbHelper.selectNotes();

      expect(notes.length, 1);
      expect(notes.first.title, title);
      expect(notes.first.done, done);
    });

    test('Update notes', () async {
      const title = 'Test note';
      const done = 0;

      await dbHelper.insertNotes(title, done);

      final notes = await dbHelper.selectNotes();
      const updatedDone = 1;

      await dbHelper.updateNotes(notes.first.id, updatedDone);

      final updatedNotes = await dbHelper.selectNotes();

      expect(updatedNotes.length, 1);
      expect(updatedNotes.first.title, title);
      expect(updatedNotes.first.done, updatedDone);
    });

    test('Delete notes', () async {
      const title = 'Test note';
      const done = 0;

      await dbHelper.insertNotes(title, done);

      final notes = await dbHelper.selectNotes();

      await dbHelper.deleteNotes(notes.first.id);

      final deletedNotes = await dbHelper.selectNotes();

      expect(deletedNotes.length, 0);
    });
  });
}
