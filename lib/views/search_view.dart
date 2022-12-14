import '../constants/colors.dart';
import '../helpers/size_helper.dart';
import '../services/l10n/app_localizations.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SearchView extends ConsumerWidget {
  const SearchView({super.key});
  static const name = 'search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0, vertical: SizeConfig.screenHeight * 0.06),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).codeInsertLabel),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ThemedInput(
                onChanged: (value) {},
                hintText: AppLocalizations.of(context).codeInsertLabel),
          ),
          ThemedButton(
              onTap: () {},
              color: secondColor,
              text: AppLocalizations.of(context).search)
        ],
      ),
    );
  }
}
