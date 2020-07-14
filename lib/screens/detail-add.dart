import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todos_bloc/blocs/blocs.dart';
import 'package:simple_todos_bloc/models/models.dart';

class DetailAddScreen extends StatefulWidget {
  final String id;
  final bool isEditing;
  const DetailAddScreen({Key key, this.id, @required this.isEditing})
      : super(key: key);

  @override
  _DetailAddScreenState createState() => _DetailAddScreenState();
}

class _DetailAddScreenState extends State<DetailAddScreen> {
  String id;
  bool isEditing;
  String _title;                        // --> ไว้เก็บ title แบบชั่วคราว
  String _detail;                       // --> ไว้เก็บ detail แบบชั่วคราว
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();        // --> key ไว้บ่งชี้ form นั้นๆ

  @override
  void initState() {
    id = widget.id;
    isEditing = widget.isEditing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todosBloc = BlocProvider.of<TodosBloc>(context);
    String title;
    String detail;

    return BlocBuilder(
        bloc: todosBloc,
        builder: (BuildContext context, TodosState state) {
          final todo = (state as TodosLoaded)
              .todos
              .firstWhere((todo) => todo.id == widget.id, orElse: () => null);      // --> ใช้ id ของ todo เพื่อนำมาดึงข้อมูลของ todo นั้นจากใน todos ถ้า id ไม่มีตัวตน ก็จะได้รับค่าเป็น null แทน
          if (todo == null) {                       // --> เมื่อ todo เป็น null เราก็จะให้ค่าตั้งต้นสำหรับ title และ detail เป็น string ว่างๆ
            title = '';
            detail = '';
          } else {                                  // --> เมื่อ todo มีค่า ก็ให้ดึงค่ามาจากใน todo
            title = todo.title;
            detail = todo.detail;
          }
          return Form(
            key: _formKey,                          // --> ใส่ key ที่สร้างด้านบน เพราะเมื่อเราต้องการดึงข้อมูลจากฟอร์มนี้ เราจะได้ดึงถูกที่
            child: Scaffold(
              appBar: AppBar(
                title: isEditing == false           // --> เลือกระหว่างจะโชว์ Text หรือ TextFormField
                    ? Text('$title')
                    : TextFormField(
                        initialValue: todo == null ? '' : todo.title,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Please name title', labelText: 'Title'),
                        validator: (val) {                  // --> เงื่อนไข validator  สำหรับ เงื่อนไข validator
                          return val.isEmpty == true
                              ? 'Please put some title!'
                              : null;
                        },
                        onSaved: (value) => _title = value,
                      ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(isEditing == false ? Icons.edit : Icons.cancel),       // --> เลือกระหว่างจะโชว์ปุ่ม แก้ไข หรือ ยกเลิก
                    onPressed: () {
                      setState(() {
                        if (todo != null) {
                          isEditing = !isEditing;
                        } else{
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                  isEditing == false ? IconButton(icon: Icon(Icons.delete),onPressed: () {    // --> โชว์ปุ่มลบเมื่อ อยู่ในสถานะไม่ได้แก้ไข
                    todosBloc.add(DeleteTodos(todo));                                    // --> เรียก event DeleteTodos
                    Navigator.pop(context);                                                   // --> เด้งหน้านี้ออกไป
                  },) : SizedBox()
                ],
              ),
              body: Container(
                  padding: EdgeInsets.all(16),
                  child: isEditing == false                                                   // --> เลือกระหว่างจะโชว์ Text หรือ TextFormField
                      ? Text('$detail')
                      : TextFormField(
                          initialValue: todo == null ? '' : todo.detail,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Any Detail you want to put',
                              labelText: 'Detail'),
                          onSaved: (value) => _detail = value,
                        )),
              floatingActionButton: isEditing == false
                  ? SizedBox()
                  : FloatingActionButton(
                      backgroundColor: Color(0xffb14934),
                      child: Icon(todo != null ? Icons.check : Icons.note_add),            // --> เลือกระหว่างจะโชว์ปุ่ม แก้ไข หรือ เพิ่มใหม่
                      onPressed: () {
                        if (_formKey.currentState.validate()) {                            // --> เช็คว่าข้อมูลใน TextFormField ถูกต้องตามเงื่อนไข validator ที่กำหนดของแต่ละอัน
                          _formKey.currentState.save();                                    // --> ย้ายข้อมูลที่เก็บชั่วคราวใน TextFormField มาใส่ใน _title กับ _detail
                          if (todo == null) {                                              // --> ถ้าเป็นการสร้าง todo ขึ้นใหม่
                            TodoModel toSave = TodoModel(
                              title: _title,
                              detail: _detail,
                              complete: false,
                            );
                            todosBloc.add(AddTodos(toSave));
                            Navigator.pop(context);                                        // --> เมื่อสร้างเสร็จเราจะเด้งหน้านี้ออกด้วย ** ไม่จำเป็นต้องเด้งออก แล้วแต่เราอยากดีไซน์เลย ถ้าไม่เด้งออก อย่าลืมนำ id ที่สร้างมาใหม่ ไปอัพเดท ให้กับ id ในหน้านี้ด้วย
                          } else {                                                         // --> ถ้าเป็นการแก้ไข todo
                            TodoModel toSave = todo.copyWith(
                              title: _title,
                              detail: _detail,
                            );
                            todosBloc.add(UpdateTodos(toSave));
                            setState(() {
                              isEditing = !isEditing;                                     // --> สลับสถานะจาก แก้ไข เป็น ไม่แก้ไข
                            });
                          }
                        }
                      },
                    ),
            ),
          );
        });
  }
}
