import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_back4app/providers/user_provider.dart';

class AppBarGradient extends StatelessWidget {
  final String title;
  final double barHeight = 60.0;
  final bool? isDeleteActive;
  final VoidCallback? onDelete;

  AppBarGradient(
      {super.key, required this.title, this.isDeleteActive, this.onDelete});

  final List<Map<String, dynamic>> menuItems = [
    // {
    //   "label": 'Profile',
    //   "icon": Icons.account_circle_sharp,
    //   "action": (BuildContext context, UserProvider userContext) {}
    // },
    {
      "label": 'Logout',
      "icon": Icons.logout,
      "action": (BuildContext context, UserProvider userContext) async {
        await userContext.signout();
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Consumer<UserProvider>(
      builder: (context, userContext, child) {
        return Container(
          padding: EdgeInsets.only(top: statusbarHeight),
          height: statusbarHeight + barHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff1E2E3D),
                  Color(0xff152534),
                  Color(0xff0C1C2E),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.5, 0.0),
                stops: [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (isDeleteActive ?? false)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext context) {
                        return menuItems
                            .map(
                              (item) => PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      item["icon"],
                                      color: Colors.grey,
                                      size: 24,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      item["label"],
                                    )
                                  ],
                                ),
                                onTap: () =>
                                    item["action"](context, userContext),
                              ),
                            )
                            .toList();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
