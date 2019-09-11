import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todos_bloc/blocs/blocs.dart';
import 'package:simple_todos_bloc/models/models.dart';
import 'package:simple_todos_bloc/widgets/widgets.dart';

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
  String _title;
  String _detail;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              .firstWhere((todo) => todo.id == widget.id, orElse: () => null);
          if (todo == null) {
            title = '';
            detail = '';
          } else {
            title = todo.title;
            detail = todo.detail;
          }
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: isEditing == false
                    ? Text('$title')
                    : TextFormField(
                        initialValue: todo == null ? '' : todo.title,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Please name title', labelText: 'Title'),
                        validator: (val) {
                          return val.isEmpty == true
                              ? 'Please put some title!'
                              : null;
                        },
                        onSaved: (value) => _title = value,
                      ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(isEditing == false ? Icons.edit : Icons.cancel),
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
                  isEditing == false ? IconButton(icon: Icon(Icons.delete),onPressed: () {
                    todosBloc.dispatch(DeleteTodos(todo));
                    Navigator.pop(context);
                  },) : SizedBox()
                ],
              ),
              body: Container(
                  padding: EdgeInsets.all(16),
                  child: isEditing == false
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
                      child: Icon(todo != null ? Icons.check : Icons.note_add),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (todo == null) {
                            TodoModel toSave = TodoModel(
                              title: _title,
                              detail: _detail,
                              complete: false,
                            );
                            todosBloc.dispatch(AddTodos(toSave));
                            //widget.onSave(toSave,true);
                            Navigator.pop(context);
                          } else {
                            TodoModel toSave = todo.copyWith(
                              title: _title,
                              detail: _detail,
                            );
                            todosBloc.dispatch(UpdateTodos(toSave));
                            setState(() {
                              isEditing = !isEditing;
                            });
                            //widget.onSave(toSave,false);
                          }
                        }
                      },
                    ),
            ),
          );
        });
  }
}
