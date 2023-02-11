import 'package:flutter/material.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/model/model.dart';

class ShowByCategoryPage extends StatefulWidget {
  final MyCategory category;
  const ShowByCategoryPage({super.key, required this.category});

  @override
  State<ShowByCategoryPage> createState() => _ShowByCategoryPageState();
}

class _ShowByCategoryPageState extends State<ShowByCategoryPage> {
  List<MyNote> not = noteContainer;

  @override
  Widget build(BuildContext context) {
    // var list = not.where(
    //   (element) => element.title == widget.category.title,
    // );
    // print();
    return Scaffold(
      appBar: AppBar(
        title: Text("Note by Category for : ${widget.category.title}"),
      ),
    );
  }
}
