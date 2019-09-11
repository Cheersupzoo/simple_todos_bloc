import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';                // --> เพื่อใช้งาน flutter_bloc
import 'package:simple_todos_bloc/blocs/blocs.dart';            // --> อิมพอร์ท bloc ที่เราสร้างขึ้นมา
import 'package:simple_todos_bloc/screens/detail-add.dart';     // --> อิมพอร์ท หน้า /detail-add.dart เพราะเมื่อเราสร้าง todo ใหม่ หรือต้องการดูรายละเอียด ก็ทำผ่านหน้านี้
import 'package:simple_todos_bloc/widgets/widgets.dart';        // --> เอา LoadingIndicator มาใช้
import 'package:flutter/cupertino.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Todo App',
        )),
        body: BlocBuilder(
            bloc: todosBloc,
            builder: (BuildContext context, TodosState state) {
              if (state is TodosLoading) {                                // --> ถ้า state เป็น TodosLoading ก็ให้โชว์ LoadingIndicator
                return LoadingIndicator(key: Key('__TodosLoading'));      
              } else if (state is TodosLoaded) {                          // --> ถ้า state เป็น TodosLoaded ก็ให้โชว์ list ของ todo
                final todos = state.todos;
                return ListView.builder(                                  // --> ใช้ ListView.builder ให้สร้าง list card ขึ้นมา
                  key: Key('__ListTodos__'),
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todos[index];
                    return Card(                                          // --> เลือกใช้ card แสดงข้อมูล todo แต่ละอัน
                      elevation: 8.0,
                      child: InkWell(                                     // --> ใส่ InkWell ครอบ เมื่่อกดปุ่มจะได้มี ripple effect
                        onTap: () =>                                      // --> เมื่อกดไปที่ card ก็จะส่งไปหน้า DetailAddScreen แบบมีรหัส id และอยู่ในสถานะ ไม่ได้แก้ไขข้อมูล
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => DetailAddScreen(
                                      id: todo.id,
                                      isEditing: false,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(                                      // --> ที่ด้านซ้ายของ card จะมีปุ่มที่ติ๊กบอกความ complete
                                onTap: () => todosBloc.dispatch(UpdateTodos(        // --> เมื่อกด เราจะทำการเรียก event UpdateTodos 
                                    todo.copyWith(complete: !todo.complete))),      // --> ใช้ copyWith เพื่อไม่ทำให้ข้อมูลเก่าถูกกลายพันธุ์
                                child: todo.complete == false
                                    ? Icon(Icons.check_box_outline_blank)
                                    : Icon(Icons.check_box),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text('${todo.title}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
        floatingActionButton: FloatingActionButton(                               // --> ปุ่มเพิ่ม todo ใหม่ จะลอยอยู่บนด้านล่างซ้าย
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(                        // --> เมื่อกดไปที่ card ก็จะส่งไปหน้า DetailAddScreen แบบ ไม่มี รหัส id และอยู่ในสถานะ แก้ไขข้อมูล
                                builder: (_) => DetailAddScreen(
                                      isEditing: true,
                                    )));
          },
        ));
  }
}
