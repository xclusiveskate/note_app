// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_app/constants/constants.dart';
// import 'package:note_app/constants/constants.dart';
import 'package:note_app/database/category_db.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/ui/notes/home.dart';
import 'package:note_app/utils/alert_dialog.dart';
import 'package:note_app/utils/float_action.dart';
import 'package:note_app/utils/show_snackbar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController titleEditC = TextEditingController();
  TextEditingController descriptionEditC = TextEditingController();

  addCategory() async {
    if (titleC.text.isNotEmpty && descriptionC.text.isNotEmpty) {
      final myCateg =
          CategoryModel(title: titleC.text, description: descriptionC.text);
      final theId = await CategoryDatabase.instance.createCategory(myCateg);
      final category = myCateg.copyWith(id: theId);
      setState(() {
        categories.add(category);
        print(categories.length);
        titleC.clear();
        descriptionC.clear();
      });
      showSnackBar(context: context, message: "New category added ");
    }
  }

  readCategory() async {
    final awaitedCategory = await CategoryDatabase.instance.readCategory();

    setState(() {
      categories = [...awaitedCategory];
    });
  }

  editCategory(CategoryModel category) async {
    if (titleEditC.text.isNotEmpty && descriptionEditC.text.isNotEmpty) {
      category.title = titleEditC.text;
      category.description = descriptionEditC.text;
      await CategoryDatabase.instance.updateCategory(category);
      readCategory();
      showSnackBar(context: context, message: "Data Updated successfully");
      setState(() {});
    }
  }

  deleteCategory(CategoryModel category) async {
    await CategoryDatabase.instance.removeCategory(category.id!);
    readCategory();
  }

  @override
  void initState() {
    super.initState();
    readCategory();
  }

  @override
  void dispose() {
    titleEditC.dispose();
    descriptionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 245, 246, 235),
          elevation: 0.5,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NotePage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(),
              ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        showEditAlert(
                            context: context,
                            titleEditC: titleEditC,
                            descriptionEditC: descriptionEditC,
                            // category: categories[index],
                            onPressed: () {
                              editCategory(categories[index]);
                              Navigator.pop(context);
                            });
                        setState(() {
                          // isEditing = true;
                          titleEditC.text = categories[index].title;
                          descriptionEditC.text = categories[index].description;
                        });
                      },
                      leading: const Icon(Icons.edit),
                      title: Text(categories[index].title),
                      subtitle: Text(
                        categories[index].description,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      trailing: IconButton(
                          onPressed: () => deleteCategory(categories[index]),
                          icon: const Icon(Icons.delete)),
                    );
                  })
            ],
          ),
        ),
        floatingActionButton: FloatButton(
            onPressed: () {
              showAlert(
                  context: context,
                  titleC: titleC,
                  descriptionC: descriptionC,
                  onPressed: () {
                    addCategory();
                    Navigator.pop(context);
                  });
            },
            icon: Icons.add));
  }
}
