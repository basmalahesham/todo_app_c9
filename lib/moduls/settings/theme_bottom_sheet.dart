import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/theme/app_theme.dart';

import '../../provider/settings_provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: provider.isDark() ? Color(0xFF141922) : Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.light);
            },
            child: provider.isDark()
                ? getUnselectedItem(AppLocalizations.of(context)!.light)
                : getSelectItem(AppLocalizations.of(context)!.light),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.dark);
            },
            child: provider.isDark()
                ? getSelectItem(AppLocalizations.of(context)!.dark)
                : getUnselectedItem(
                    AppLocalizations.of(context)!.dark,
                  ),
          ),
        ],
      ),
    );
  }

  Widget getSelectItem(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.check,
            color: Theme.of(context).canvasColor,
          ),
        ],
      ),
    );
  }

  Widget getUnselectedItem(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
