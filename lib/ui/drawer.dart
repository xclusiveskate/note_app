import 'package:flutter/material.dart';
import 'package:note_app/model/category_model.dart';
import 'package:note_app/ui/category.dart';
import 'package:note_app/ui/home.dart';
import 'package:note_app/ui/show_by_category.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                currentAccountPicture: const CircleAvatar(),
                accountName: const Text("Miran Steeve"),
                accountEmail: const Text("steevemyrank@gmail.com")),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => const MyNoteApp()))),
            ),
            ListTile(
                leading: const Icon(Icons.view_list_sharp),
                title: const Text("Categories"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CategoryScreen())));
                }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 36),
              child: Container(
                  child: ListView.builder(
                      itemCount: myCategories.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: ((context, index) {
                        final myCateg = myCategories[index];
                        return ListTile(
                          onTap: () {
                            print(myCateg.title);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ShowByCategoryPage(
                                        category: myCategories[index]))));
                          },
                          title: Text("${index + 1}  :  ${myCateg.title}"),
                        );
                      }))),
            )
          ],
        ),
      ),
    );
  }
}
