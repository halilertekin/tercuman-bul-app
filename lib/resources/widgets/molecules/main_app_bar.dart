import 'package:flutter/material.dart';
import 'package:flutter_app/app/services/auth_service.dart';
import 'package:flutter_app/resources/pages/auth_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../../app/models/languages.dart';
import '../../themes/styles/light_theme_colors.dart';
import '../atoms/country_flag_name.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 0,
      centerTitle: false,
      backgroundColor: LightThemeColors().white,
      title: SizedBox(
        height: 32.0,
        child: Image.asset('public/assets/images/logo_horiz.png'),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: Row(
            children: [
              PopupMenuButton(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Icon(
                        MdiIcons.web,
                        color: LightThemeColors().context,
                      ),
                    ),
                    Text(
                      Languages.nativeLocaleName(
                          NyLocalization.instance.languageCode),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: LightThemeColors().context,
                    ),
                  ],
                ),
                itemBuilder: (context) => Languages.appLanguages
                    .map(
                      (e) => PopupMenuItem(
                        child: CountryFlagName(
                          code: e.key,
                          name: Languages.nativeLocaleName(e.key),
                          type: 'lang',
                        ),
                        value: e.key,
                      ),
                    )
                    .toList(),
                onSelected: (value) async {
                  await NyLocalization.instance
                      .setLanguage(context, language: value);
                },
              ),
              AuthService().hasSession
                  ? IconButton(
                      tooltip: "logout".tr(),
                      onPressed: () async {
                        await AuthService().logout();
                        routeTo(AuthPage.path);
                      },
                      icon: Icon(
                        MdiIcons.logout,
                        color: LightThemeColors().context,
                      ),
                    )
                  : IconButton(
                      tooltip: "login".tr(),
                      onPressed: () {
                        routeTo(AuthPage.path);
                      },
                      icon: Icon(
                        MdiIcons.login,
                        color: LightThemeColors().context,
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}
