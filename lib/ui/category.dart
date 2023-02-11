import 'package:flutter/material.dart';
import 'package:note_app/database/category_db.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/ui/home.dart';
import 'package:overlay_support/overlay_support.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // MyCategory category = MyCategory(title: '', description: '');
  // addCategory() {
  //   if (categTitleController.text.isNotEmpty &&
  //       categDescriptionController.text.isNotEmpty) {
  //     var addIt = MyCategory(
  //         title: categTitleController.text,
  //         description: categDescriptionController.text);
  //     setState(() {
  //       myCategories.add(addIt);
  //       print(myCategories.length);
  //     });
  //     categTitleController.clear();
  //     categDescriptionController.clear();
  //     Navigator.pop(context);
  //   } else {
  //     toast("Category field is empty");
  //   }
  // }

  @override
  void initState() {
    readCategory();
    super.initState();
  }

  TextEditingController categTitleController = TextEditingController();
  TextEditingController categDescriptionController = TextEditingController();
  addCategory() async {
    if (categTitleController.text.isNotEmpty &&
        categDescriptionController.text.isNotEmpty) {
      final myCategory = MyCategory(
          title: categTitleController.text,
          description: categDescriptionController.text);
      final theId = await CategoryDataBase.categoryDataBaseInstance
          .createCategory(myCategory);
      final category = myCategory.copyWith(id: theId);

      setState(() {
        myCategories.add(category);
        categTitleController.clear();
        categDescriptionController.clear();
        Navigator.pop(context);
        toast("one category  successfully");
      });
    }
  }

  readCategory() async {
    final awaitedCategory =
        await CategoryDataBase.categoryDataBaseInstance.readCategory();
    setState(() {
      myCategories = [...awaitedCategory];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => const MyNoteApp()))),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text("This is category"),
      ),
      body: Column(
        children: [
          ListView.builder(
              itemCount: myCategories.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: ((context, index) {
                final myCateg = myCategories[index];
                return ListTile(
                  onTap: () {},
                  title: Text(myCateg.title),
                  subtitle: Text(myCateg.description),
                );
              })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  showCategoryForm(BuildContext context) async {
    return await showDialog(
        barrierDismissible: true,
        barrierColor: const Color.fromARGB(255, 249, 228, 164).withOpacity(.5),
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.amber.withOpacity(.6),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Categories of Note"),
                TextField(
                  controller: categTitleController,
                  decoration: const InputDecoration(
                      hintText: "Write your title here", labelText: "Title"),
                ),
                TextField(
                  controller: categDescriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write your description here",
                      labelText: "Description"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: addCategory,
                        child: const Text("Add Category")),
                  ],
                )
              ],
            ),
          );
        }));
  }
}
