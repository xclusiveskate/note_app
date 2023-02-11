import 'package:flutter/material.dart';
import 'package:note_app/database/db.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/model/model.dart';

class EditPage extends StatefulWidget {
  final MyNote? myNote;
  const EditPage({super.key, this.myNote});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String categoryValue = "Uncategorized";

  TextEditingController titleControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  TextEditingController categoryControl = TextEditingController();
  sendNote() async {
    if (titleControl.text.isNotEmpty && contentControl.text.isNotEmpty) {
      final myNote = MyNote(
          title: titleControl.text,
          content: contentControl.text,
          date: DateTime.now(),
          category: categoryValue.toString(),
          isCompleted: false);
      final theId = await NoteDatabase.noteDatabaseInstance.createNote(myNote);
      final note = myNote.copyWith(id: theId);
      setState(() {
        noteContainer.add(note);
        titleControl.clear();
        contentControl.clear();
      });
      print(theId);
      print(noteContainer.length);
      print(noteContainer);
    }
  }

  List<MyNote> noteContainer = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.done_outline,
                size: 30,
              ))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(
              controller: titleControl,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            DropdownButton(
                value: categoryValue,
                isExpanded: true,
                hint: const Text("Choose Category"),
                items: myCategories
                    .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.title)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    categoryValue = val.toString();
                  });
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TextField(
                controller: contentControl,
                maxLines: null,
                minLines: null,
                expands: true,
                decoration: const InputDecoration(
                    hintText: "Start Typing your Content",
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
