import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sql/db_helper.dart';
import 'package:sql/todo.dart';
import 'package:sql/todo_page.dart';

class MockDbHelper extends Mock implements Dbhelper {
  @override
  Future<List<Todo>> selectNotes() async {
    return super.noSuchMethod(
      Invocation.method(#selectNotes, []),
      returnValue: Future.value([Todo(id: 1, title: "", done: 1)]),
    );
  }

  @override
  Future<void> insertNotes(String title, int done) async {
    return super.noSuchMethod(
      Invocation.method(#insertNotes, [title, done]),
      returnValue: Future.value(),
    );
  }

  @override
  Future<void> updateNotes(int id, int done) async {
    return super.noSuchMethod(
      Invocation.method(#updateNotes, [id, done]),
      returnValue: Future.value(),
    );
  }

  @override
  Future<void> deleteNotes(int id) async {
    return super.noSuchMethod(
      Invocation.method(#deleteNotes, [id]),
      returnValue: Future.value(),
    );
  }
}

void main() {
  late MockDbHelper mockDbHelper;
  setUp(() async {
    databaseFactoryOrNull = null;

    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;

    mockDbHelper = MockDbHelper();

    // Return some notes from selectNotes
    when(mockDbHelper.selectNotes()).thenAnswer(
      (_) => Future.value(
        [
          Todo(
            id: 1,
            title: 'Note 1',
            done: 0,
          ),
          Todo(
            id: 2,
            title: 'Note 2',
            done: 1,
          ),
        ],
      ),
    );
    // Return a Future that completes successfully when insertNotes is called

    // Initialize databaseFactory
  });
  group('TodoPage', () {
    testWidgets('should display the title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TodoPage(title: 'My Todo List'),
        ),
      );

      expect(find.text('My Todo List'), findsOneWidget);
    });
    // tap to add
    testWidgets("create to test to add button ", (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          home: TodoPage(title: 'My Todo List', dbHelper: mockDbHelper),
        ),
      );

      when(mockDbHelper.insertNotes("any", 1))
          .thenAnswer((_) => Future.value());
      await widgetTester.tap(find.text("adicionar"));
      await widgetTester.pump();

      // pump await
    });

    testWidgets('should display notes', (WidgetTester tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: TodoPage(title: 'My Todo List', dbHelper: mockDbHelper),
        ),
      );

      // Verify that CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      // Verify that CircularProgressIndicator is not displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('Note 1 e id: 1'), findsOneWidget);
      expect(find.text('Note 2 e id: 2'), findsOneWidget);
    });

    testWidgets('should select todo and change to done',
        (WidgetTester tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: TodoPage(title: 'My Todo List', dbHelper: mockDbHelper),
        ),
      );

      // Verify that CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      // Verify that CircularProgressIndicator is not displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('Note 1 e id: 1'), findsOneWidget);
      expect(find.text('Note 2 e id: 2'), findsOneWidget);

      await tester.tap(find.byType(Switch).first);
      await tester.pump();

      verify(mockDbHelper.updateNotes(1, 1)).called(1);

      final dataVerify = await mockDbHelper.selectNotes();
      expect(dataVerify.last.done, 1);
    });

    // delete te todo
    testWidgets('should delete todo', (WidgetTester tester) async {
      // Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: TodoPage(title: 'My Todo List', dbHelper: mockDbHelper),
        ),
      );
      when(mockDbHelper.deleteNotes(1)).thenAnswer((_) {
        return Future.value();
      });

      // Verify that CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      // Verify that CircularProgressIndicator is not displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('Note 1 e id: 1'), findsOneWidget);
      expect(find.text('Note 2 e id: 2'), findsOneWidget);

      await tester.tap(find.text("delete").first);
      await tester.pumpAndSettle();
      verify(mockDbHelper.deleteNotes(1)).called(1);
    });
  });
}
