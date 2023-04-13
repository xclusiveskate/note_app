// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_app/constants/constants.dart';
import 'package:note_app/database/category_db.dart';

import 'package:note_app/database/db.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/utils/show_snackbar.dart';

class AddNote extends StatefulWidget {
  MyNote? note;
  AddNote({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  ScrollController scrollControl = ScrollController();

  addNote() async {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      final theNote = MyNote(
        title: titleController.text,
        content: contentController.text,
        date: DateTime.now(),
        category: selectedValue!,
      );
      final theId = await NoteDatabase.instance.createNote(theNote);
      final note = theNote.copyWith(id: theId);
      setState(() {
        notes.add(note);
        print(notes.length);
      });
      showSnackBar(context: context, message: 'note added successfully');

      Navigator.pop(context);
    } else {
      showSnackBar(context: context, message: "Field is empty");
    }
  }

  updateNote() async {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.category = selectedValue!;
    await NoteDatabase.instance.updateNote(widget.note!);

    showSnackBar(context: context, message: "Note updated Successfully");
    Navigator.pop(context);
  }

  _AddNoteState() {
    selectedValue = dropDownItems[0];
  }
  List dropDownItems = <String>["Uncategorized"];

  loadCategory() async {
    var categories = await CategoryDatabase.instance.readCategory();
    for (var e in categories) {
      setState(() {
        dropDownItems.add(e.title.toString());
      });
    }
  }

  String? selectedValue;

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      selectedValue = widget.note!.category;
    }
    loadCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 246, 235),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        elevation: 0.5,
        actions: [
          const IconButton(
              onPressed: null,
              tooltip: "Undo",
              icon: Icon(
                Icons.undo,
                size: 26,
                color: Color.fromARGB(255, 220, 166, 5),
                weight: 1,
              )),
          const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.redo,
                size: 26,
                color: Color.fromARGB(255, 220, 166, 5),
                weight: 1,
              )),
          IconButton(
              onPressed: widget.note != null ? updateNote : addNote,
              icon: const Icon(
                Icons.done,
                size: 26,
                color: Color.fromARGB(255, 220, 166, 5),
                weight: 1,
              ))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollControl,
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: "Enter title",
              ),
            ),
            DropdownButton(
                hint: const Text("Choose Category"),
                isExpanded: true,
                items: dropDownItems
                    .map<DropdownMenuItem<String>>((e) =>
                        DropdownMenuItem<String>(
                            value: e.toString(), child: Text(e.toString())))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                  });
                }),
            TextField(
              maxLines: null,
              minLines: null,
              // expands: true,
              controller: contentController,

              decoration: const InputDecoration(
                  hintText: "Start typing contents",
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            )
          ],
        ),
      ),
    );
  }
}
