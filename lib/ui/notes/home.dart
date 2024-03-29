import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/constants.dart';
import 'package:note_app/database/db.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/ui/notes/add_note.dart';
import 'package:note_app/ui/notes/drawer.dart';
import 'package:note_app/utils/float_action.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  readNote() async {
    final awaitedNotes = await NoteDatabase.instance.readNote();
    setState(() {
      notes = [...awaitedNotes];
    });
  }

  deleteNote(MyNote note) async {
    await NoteDatabase.instance.deleteNote(note.id!);
    readNote();
  }

  bulkDelete() {
    for (var element in selectedNotes) {
      deleteNote(element);
    }
    setState(() {
      startSelecting = false;
      selectedNotes = [];
    });
  }

  String formatDate(DateTime date) {
    var now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (date.isAfter(today)) {
      return DateFormat.jm().format(date);
    } else if (date.isAfter(yesterday)) {
      return ' yesterday';
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }

  TextEditingController searchController = TextEditingController();
  ScrollController scroll = ScrollController();

  @override
  void initState() {
    readNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        appBar: startSelecting
            ? AppBar(
                leading: BackButton(
                  onPressed: () {
                    setState(() {
                      startSelecting = false;
                      selectedNotes = [];
                    });
                  },
                ),
                title: Text(
                  '${selectedNotes.length}/${notes.length} notes selected',
                  style: content.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      fontStyle: FontStyle.italic),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        // if (selectedNotes.isNotEmpty) {
                        //   setState(() {
                        //     selectedNotes.clear();
                        //   });
                        // }
                      },
                      icon: const Icon(Icons.check_circle_outline)),
                  IconButton(
                      onPressed: () async {
                        selectedNotes.isNotEmpty
                            ? await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Are you sure you want to delete??",
                                        style: title.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    content: const Text(
                                        "N:B : Contents deleted cannot be retrieved"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            bulkDelete();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete"))
                                    ],
                                  );
                                })
                            : null;
                      },
                      icon: const Icon(Icons.delete)),
                ],
              )
            : defaultAppBar(width),
        drawer: const DrawerNav(),
        body: notes.isEmpty
            ? const Center(
                child: Text("No notes added yet"),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: isListView ? noteGridView() : noteListView(),
              ),
        floatingActionButton: FloatButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddNote()));
            },
            icon: Icons.add));
  }

  AppBar defaultAppBar(double width) {
    return AppBar(
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        actions: [
          isSearching
              ? SizedBox(
                  height: 30,
                  width: width / 1.6,
                  child: TextField(
                    controller: searchController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      searchNotes.clear();
                      for (var note in notes) {
                        if (note.category.toLowerCase().contains(value) ||
                            note.content.toLowerCase().contains(value) ||
                            note.title.toLowerCase().contains(value)) {
                          setState(() {
                            searchNotes.add(note);
                          });
                        } else {
                          setState(() {});
                        }
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 2),
                        hintText: "Search notes",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ))
              : const SizedBox.shrink(),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: isSearching
                  ? const Text(
                      "cancel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Icon(Icons.search)),
          PopupMenuButton(
              onSelected: (value) {
                print(value);
              },
              onCanceled: () {},
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        setState(() {
                          isListView = !isListView;
                        });
                      },
                      value: 1,
                      child: isListView
                          ? const Text("ListView")
                          : const Text("GridView")),
                  PopupMenuItem(
                      onTap: () {}, value: 2, child: const Text("Settings")),
                ];
              })
        ]);
  }

  ListView noteListView() {
    return ListView.builder(
        shrinkWrap: true,
        controller: scroll,
        reverse: true,
        itemCount: isSearching ? searchNotes.length : notes.length,
        itemBuilder: (context, index) {
          var note = isSearching ? searchNotes[index] : notes[index];

          return ListTile(
            onLongPress: () {
              setState(() {
                startSelecting = true;
                if (selectedNotes.isEmpty) {
                  selectedNotes.add(note);
                }
              });
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNote(
                            note: note,
                          )));
            },
            title: Text(
              note.title,
              style: title,
            ),
            subtitle: Text(
              note.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: content,
            ),
            trailing: startSelecting
                ? IconButton(
                    onPressed: () {
                      bool isExisted =
                          selectedNotes.any((element) => element.id == note.id);
                      if (isExisted) {
                        setState(() {
                          selectedNotes
                              .removeWhere((element) => element.id == note.id);
                        });
                      } else {
                        setState(() {
                          selectedNotes.add(note);
                        });
                      }
                    },
                    icon: Icon(
                      selectedNotes.any((element) => element.id == note.id)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: Colors.amber,
                    ))
                : Text(
                    formatDate(
                      note.date,
                    ),
                    style: content.copyWith(fontSize: 14),
                  ),
          );
        });
  }

  GridView noteGridView() {
    return GridView.builder(
        shrinkWrap: true,
        controller: scroll,
        // reverse: true,
        itemCount: isSearching ? searchNotes.length : notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 0.9, mainAxisSpacing: 0.5),
        itemBuilder: (context, index) {
          var note = isSearching ? searchNotes[index] : notes[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onLongPress: () {
                setState(() {
                  startSelecting = true;
                  if (selectedNotes.isEmpty) {
                    selectedNotes.add(note);
                  }
                });
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNote(
                              note: note,
                            )));
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          note.title,
                          style: title,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            note.content,
                            style: content),
                        startSelecting
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        bool isExisted = selectedNotes.any(
                                            (element) => element.id == note.id);
                                        if (isExisted) {
                                          setState(() {
                                            selectedNotes.removeWhere(
                                                (element) =>
                                                    element.id == note.id);
                                          });
                                        } else {
                                          setState(() {
                                            selectedNotes.add(note);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        selectedNotes.any((element) =>
                                                element.id == note.id)
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: Colors.amber,
                                      )),
                                  Text(
                                    formatDate(
                                      note.date,
                                    ),
                                    style: content.copyWith(fontSize: 14),
                                  ),
                                ],
                              )
                            : Text(
                                formatDate(note.date),
                                style: content.copyWith(fontSize: 14),
                              )
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}

// bool isEditing = true;
