import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uni_app/core/common/widgets/my_list_tile.dart';
import 'package:uni_app/features/admin/presentation/pages/home/drawer/add_shop_page.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              'A D M I N',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.inverseSurface,
            thickness: 0.5,
            indent: 20,
            endIndent: 20,
          ),
          MySettingsTile(
            title: 'Add new shop',
            leading: const FaIcon(
              FontAwesomeIcons.plus,
              size: 18,
            ),
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // navigate to add shop page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddShopPage()));
            },
          ),
          // MySettingsTile(
          //   title: 'Add new barber',
          //   leading: const FaIcon(
          //     FontAwesomeIcons.plus,
          //     size: 18,
          //   ),
          //   onTap: () {
          //     // pop drawer
          //     Navigator.pop(context);

          //     // navigate to add barber page
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => const AddBarberPage()));
          //   },
          // ),
        ],
      ),
    );
  }
}
