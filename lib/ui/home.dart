import 'package:flutter/material.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/ui/drawer.dart';
import 'package:note_app/ui/edit_page.dart';

class MyNoteApp extends StatefulWidget {
  const MyNoteApp({super.key});

  @override
  State<MyNoteApp> createState() => _MyNoteAppState();
}

class _MyNoteAppState extends State<MyNoteApp> {
  ScrollController scrollController = ScrollController();
  TextEditingController titleControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  String? categoryValue;
  _MyNoteAppState() {
    categoryValue = categories.first;
  }
  @override
  void initState() {
    super.initState();
  }

  List categories = ["uncategorized", "Personal", "Education", "Work"];

  // List<MyNote> noteContainer = [];
  List<MyNote> listOfNote = noteContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 209, 209),
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("My Note App"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton(
              tooltip: "See more",
              position: PopupMenuPosition.over,
              onCanceled: (() {
                print("No Item selected");
              }),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: ((context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                        isGridView ? print("Grid") : print('List');
                      },
                      value: 1,
                      child: isGridView
                          ? const Text("List View")
                          : const Text("Grid View")),
                  PopupMenuItem(
                      onTap: () {}, value: 2, child: const Text("Settings"))
                ];
              }),
              child: const Icon(Icons.more_vert))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextField(
                strutStyle: const StrutStyle(height: 0, fontSize: 30),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search notes",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.cancel))),
              ),
              const SizedBox(
                height: 20,
              ),
              isGridView
                  ? GridView.builder(
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      // itemCount: 10,
                      itemCount: noteContainer.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10),
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text("fdfifuebbeuf"),
                                // Text("dcdhvdkuwpeoifwpefiwef"),

                                Text(noteContainer[index].title),
                                Text(
                                  noteContainer[index].content,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(noteContainer[index].date.toString()),
                              ],
                            ),
                          ),
                        );
                      }))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: noteContainer.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(noteContainer[index].title),
                          subtitle: Text(noteContainer[index].content),
                          trailing: Text(noteContainer[index].date.toString()),
                        );
                      }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return const EditPage();
          })));
        },
        backgroundColor: Colors.blue,
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }

  bool isGridView = true;
}
