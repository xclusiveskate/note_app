import 'package:flutter/material.dart';
import 'package:note_app/constants/constants.dart';
import 'package:note_app/database/category_db.dart';
import 'package:note_app/ui/category/category.dart';
import 'package:note_app/ui/notes/home.dart';
import 'package:note_app/ui/notes/show_by_category.dart';

class DrawerNav extends StatefulWidget {
  const DrawerNav({super.key});

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  readCategory() async {
    final awaitedCategory = await CategoryDatabase.instance.readCategory();
    setState(() {
      categories = [...awaitedCategory];
    });
  }

  @override
  void initState() {
    super.initState();
    readCategory();
  }

  // AdvancedDrawerContoller drawerContoller = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 245, 246, 235),
        width: MediaQuery.of(context).size.width / 1.7,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 246, 235),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                accountName: Text(
                  "Mike Francisco",
                  style: title.copyWith(color: Colors.blueGrey),
                ),
                accountEmail: Text(
                  "mikedasleek2022@gmail.com",
                  style: content.copyWith(
                    color: Colors.blueGrey,
                  ),
                )),
            ListTile(
              leading: const Icon(
                Icons.home,
                weight: 8,
                color: Color.fromARGB(255, 95, 94, 94),
              ),
              title: Text(
                "Home",
                style: content,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NotePage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.category,
                weight: 8,
                color: Color.fromARGB(255, 95, 94, 94),
              ),
              title: Text(
                "Categories",
                style: content,
              ),
              onTap: () {
                // Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 2.0,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShowByCategory(
                                      category: categories[index].title,
                                    )),
                          );
                        },
                        leading: Text(
                          "${index + 1}.",
                          style: content.copyWith(fontSize: 18),
                        ),
                        title: Text(
                          categories[index].title,
                          style: content.copyWith(fontSize: 18),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
