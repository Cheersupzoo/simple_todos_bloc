import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_todos_bloc/blocs/blocs.dart';

import 'package:simple_todos_bloc/models/models.dart';
import 'package:simple_todos_bloc/screens/screens.dart';
import 'package:simple_todos_bloc/widgets/loading_indicator.dart';

class MockTodosBloc extends MockBloc< TodosState> 
    implements TodosBloc {}

void main() {
  group('basicWidgetTest', () {
    testWidgets('checkLoadingIndicator', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(LoadingIndicator());

      Widget loadingIndicator =
          new CircularProgressIndicator(key: Key("loading_indicator"));

      expect(find.byKey(Key("loading_indicator")), findsOneWidget);
    });
  });

  group('todosScreen', () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });

    testWidgets('should loading indicator when state is TodosLoading',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoading(),
        );

        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: TodosScreen(),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        // Show AppBar
        expect(find.text('Todo App'), findsOneWidget);

        Key loadingWidget = Key('__TodosLoading');

        expect(find.byKey(loadingWidget), findsOneWidget);
      });
    });

    testWidgets('should show Todos when state is TodosLoaded',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoaded(TodoList.fromJson(mockTodos).todos),
        );

        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: TodosScreen(),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        // Show AppBar
        expect(find.text('Todo App'), findsOneWidget);

        expect(find.text('Welcome to Simple Todo'), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Test Again with null Detail'), findsOneWidget);

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.check_box_outline_blank), findsWidgets);
        expect(find.byIcon(Icons.check_box), findsNothing);
      });
    });

    testWidgets('should show Todos with Complete when state is TodosLoaded',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoaded(TodoList.fromJson(mockTodosWithComplete).todos),
        );

        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: TodosScreen(),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        // Show AppBar
        expect(find.text('Todo App'), findsOneWidget);

        expect(find.text('Welcome to Simple Todo'), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Test Again with null Detail'), findsOneWidget);

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.check_box_outline_blank), findsWidgets);
        expect(find.byIcon(Icons.check_box), findsOneWidget);
      });
    });
  });

  group("DetailAddScreen", () {
    TodosBloc todosBloc;

    setUp(() {
      todosBloc = MockTodosBloc();
    });
    testWidgets('should show DetailScreen with data when state is TodosLoaded',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoaded(TodoList.fromJson(mockTodos).todos),
        );
        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: DetailAddScreen(id: '3d4-fc56015',isEditing: false,),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Test'), findsOneWidget);
        expect(find.text('1234'), findsOneWidget);
        
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });
    });

    testWidgets('should show DetailScreen with data editing when state is TodosLoaded',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoaded(TodoList.fromJson(mockTodos).todos),
        );
        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: DetailAddScreen(id: '3d4-fc56015',isEditing: false,),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pump();

        expect(find.text('Test'), findsOneWidget);
        expect(find.text('1234'), findsOneWidget);
        
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byIcon(Icons.delete), findsNothing);

        expect(find.byIcon(Icons.cancel), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.note_add), findsNothing);
      });
    });

    testWidgets('should show DetailScreen on New data when state is TodosLoaded',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(todosBloc.state).thenAnswer(
          (_) => TodosLoaded(TodoList.fromJson(mockTodos).todos),
        );
        // Build our app and trigger a frame.
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider<TodosBloc>.value(value: todosBloc),
          ],
          child: MaterialApp(
            home: DetailAddScreen(isEditing: true,),
          ),
        ));
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Detail'), findsOneWidget);
        
        expect(find.byIcon(Icons.cancel), findsOneWidget);
        expect(find.byIcon(Icons.note_add), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsNothing);
      });
    });
  });
}

const mockTodos = {
  "todos": [
    {
      "complete": false,
      "id": "603-a2e165a",
      "title": "Welcome to Simple Todo",
      "detail": ""
    },
    {"complete": false, "id": "3d4-fc56015", "title": "Test", "detail": "1234"},
    {
      "complete": false,
      "id": "be4-3a3bd3b",
      "title": "Test Again with null Detail",
      "detail": ""
    }
  ]
};

const mockTodosWithComplete = {
  "todos": [
    {
      "complete": false,
      "id": "603-a2e165a",
      "title": "Welcome to Simple Todo",
      "detail": ""
    },
    {"complete": true, "id": "3d4-fc56015", "title": "Test", "detail": "1234"},
    {
      "complete": false,
      "id": "be4-3a3bd3b",
      "title": "Test Again with null Detail",
      "detail": ""
    }
  ]
};
