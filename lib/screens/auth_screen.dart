import '../services/wifi_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../helpers/size_helper.dart';
import '../providers/auth_provider.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import '../widgets/ui/dialog_messages.dart';
import '../widgets/utility/empty_scroll_behaviour.dart';
import 'container_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImgRoute), fit: BoxFit.fill)),
          child: CustomScrollView(
            scrollBehavior: EmptyScrollBehaviour(),
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: SizedBox(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.screenHeight * 0.11,
                        bottom: SizeConfig.screenHeight * 0.07,
                        right: SizeConfig.screenWidth * 0.14,
                        left: SizeConfig.screenWidth * 0.14),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(logoImageRoute),
                          _buildTitle(context),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.screenHeight * 0.02),
                            child: AuthForm(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth * 0.07),
                            child: _buildFooter(context),
                          ),
                        ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Column _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).emailLabel,
          style: const TextStyle(
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'info@trisimple.pt',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.01,
        ),
        Text(
          '${AppLocalizations.of(context).version}: 1.0.0',
          style: TextStyle(fontSize: 11, color: thirdColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Padding _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.04),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).reservedArea,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'DEVOPS',
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

String _password = '';

class AuthForm extends StatelessWidget {
  final inputSpacement = SizedBox(
    height: SizeConfig.screenHeight * 0.02,
  );
  AuthForm({super.key});

  _buildSubmitButton() {
    return Consumer(
      builder: (context, ref, container) {
        return ThemedButton(
            onTap: () async {
              final isConnected = await checkWifi();
              if (!isConnected) {
                await showMessageDialog(
                    context,
                    DialogMessage(
                      content: AppLocalizations.of(context).connectionError,
                      title: AppLocalizations.of(context).tryAgain,
                    ));
              } else {
                if (_password.isNotEmpty) {
                  bool valid = await ref
                      .read(authProvider.notifier)
                      .authenticate(_password);
                  if (valid) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContainerScreen()),
                    );
                  } else {
                    await showMessageDialog(
                        context,
                        DialogMessage(
                            title: 'Upsss!',
                            content:
                                AppLocalizations.of(context).wrongPassword));
                  }
                } else {
                  await showMessageDialog(
                      context,
                      DialogMessage(
                          title: 'Upsss!',
                          content: AppLocalizations.of(context).fillAllFields));
                }
              }
            },
            text: AppLocalizations.of(context).signIn);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppLocalizations.of(context).authorizedPeople,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          inputSpacement,
          PasswordInput(
            onChanged: (value) {
              _password = value;
            },
          ),
          inputSpacement,
          _buildSubmitButton(),
        ],
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final Function(String) onChanged;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return ThemedInput(
      onChanged: widget.onChanged,
      obscureText: _isPasswordHidden,
      hintText: AppLocalizations.of(context).passwordHint,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordHidden
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        },
      ),
    );
  }
}
