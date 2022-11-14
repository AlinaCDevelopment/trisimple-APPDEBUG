import 'package:app_4/helpers/size_helper.dart';
import 'package:app_4/widgets/themed_button.dart';
import 'package:app_4/widgets/themed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          ThemedButton(onTap: () {}, text: AppLocalizations.of(context).search)
        ],
      ),
    );
  }
}
