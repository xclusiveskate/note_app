import 'package:flutter/material.dart';
import 'package:note_app/constants/constants.dart';
import 'package:note_app/database/db.dart';

class ShowByCategory extends StatefulWidget {
  final String category;
  const ShowByCategory({
    super.key,
    required this.category,
  });

  @override
  State<ShowByCategory> createState() => _ShowByCategoryState();
}

class _ShowByCategoryState extends State<ShowByCategory> {
  @override
  void initState() {
    readNoteByCategory();
    super.initState();
  }

  readNoteByCategory() async {
    var notes = await NoteDatabase.instance.readNoteByCategory(widget.category);

    setState(() {
      notesByCategory = [...notes];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(widget.category),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: notesByCategory.length,
          itemBuilder: (context, index) {
            var noteByCateg = notesByCategory[index];
            return ListTile(
              onTap: () {},
              title: Text(noteByCateg.title),
              subtitle: Text(noteByCateg.content),
            );
          }),
    );
  }
}
