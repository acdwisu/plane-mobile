// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/Authentication/google_sign_in.dart';
import 'package:plane_startup/screens/on_boarding/auth/signUp.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/screens/home_screen.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/widgets/resend_code_button.dart';

import '../../../provider/provider_list.dart';
import '../../../widgets/custom_text.dart';
import 'setup_workspace.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  GlobalKey<FormState> gkey = GlobalKey<FormState>();

  final controller = PageController();
  final formKey = GlobalKey<FormState>();
  int currentpge = 0;
  TextEditingController email = TextEditingController();
  TextEditingController code = TextEditingController();
  bool sentCode = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var authProvider = ref.watch(ProviderList.authProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: gkey,
            child: LoadingWidget(
              loading: authProvider.sendCodeState == StateEnum.loading ||
                  authProvider.validateCodeState == StateEnum.loading ||
                  workspaceProvider.workspaceInvitationState ==
                      StateEnum.loading,
              widgetClass: SizedBox(
                // height: height,
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/svg_images/logo.svg'),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          children: [
                            CustomText(
                              'Sign In to',
                              type: FontStyle.heading,
                            ),
                            CustomText(
                              ' Plane',
                              type: FontStyle.heading,
                              color: primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        sentCode
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromRGBO(9, 169, 83, 0.15),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Color.fromRGBO(9, 169, 83, 1),
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        'Please check your mail for code',
                                        type: FontStyle.text,
                                        color: Color.fromRGBO(9, 169, 83, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        sentCode
                            ? const SizedBox(
                                height: 20,
                              )
                            : Container(),
                        const CustomRichText(
                          widgets: [
                            TextSpan(text: 'Email'),
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ],
                          type: RichFontStyle.text,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: email,
                          decoration: kTextFieldDecoration.copyWith(),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return '*Enter your email';
                            }

                            //check if firt letter is uppercase
                            if (val[0] == val[0].toUpperCase()) {
                              return "*First letter can't be uppercase";
                            }

                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)) {
                              return '*Please Enter valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        sentCode
                            ? const CustomRichText(
                                widgets: [
                                  TextSpan(text: 'Enter code'),
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red))
                                ],
                                type: RichFontStyle.text,
                              )
                            : Container(),
                        sentCode
                            ? const SizedBox(
                                height: 5,
                              )
                            : Container(),
                        sentCode
                            ? TextFormField(
                                controller: code,
                                decoration: kTextFieldDecoration,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter the code";
                                  }
                                  return null;
                                },
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        sentCode
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ResendCodeButton(
                                    signUp: true,
                                    email: email.text,
                                  ),
                                ],
                              )
                            : Container(),
                        sentCode
                            ? const SizedBox(
                                height: 30,
                              )
                            : Container(),
                        Hero(
                          tag: 'button',
                          child: Button(
                            text: !sentCode ? 'Send code' : 'Log In',
                            ontap: () async {
                              log(email.text);
                              if (validateSave()) {
                                if (!sentCode) {
                                  await ref
                                      .read(ProviderList.authProvider)
                                      .sendMagicCode(email.text);
                                  setState(() {
                                    sentCode = true;
                                  });
                                } else {
                                  await ref
                                      .read(ProviderList.authProvider)
                                      .validateMagicCode(
                                          key: "magic_${email.text}",
                                          token: code.text)
                                      .then(
                                    (value) async {
                                      if (authProvider.validateCodeState ==
                                              StateEnum.success &&
                                          profileProvider.getProfileState ==
                                              StateEnum.success) {
                                        if (profileProvider
                                            .userProfile.isOnboarded!) {
                                          // await workspaceProvider
                                          //     .getWorkspaces()
                                          //     .then((value) {
                                          //   if (workspaceProvider
                                          //       .workspaces.isEmpty) {
                                          //     return;
                                          //   }
                                          //   //  log(prov.userProfile.last_workspace_id.toString());

                                          //   ref
                                          //       .read(ProviderList
                                          //           .projectProvider)
                                          //       .getProjects(
                                          //           slug: workspaceProvider
                                          //               .workspaces
                                          //               .where((element) {
                                          //         if (element['id'] ==
                                          //             profileProvider
                                          //                 .userProfile
                                          //                 .last_workspace_id) {
                                          //           // workspaceProvider
                                          //           //         .currentWorkspace =
                                          //           //     element;
                                          //           workspaceProvider
                                          //                   .selectedWorkspace =
                                          //               WorkspaceModel
                                          //                   .fromJson(
                                          //                       element);
                                          //           return true;
                                          //         }
                                          //         return false;
                                          //       }).first['slug']);
                                          //   ref
                                          //       .read(ProviderList
                                          //           .projectProvider)
                                          //       .favouriteProjects(
                                          //           index: 0,
                                          //           slug: workspaceProvider
                                          //               .workspaces
                                          //               .where((element) =>
                                          //                   element['id'] ==
                                          //                   profileProvider
                                          //                       .userProfile
                                          //                       .last_workspace_id)
                                          //               .first['slug'],
                                          //           method: HttpMethod.get,
                                          //           projectID: "");
                                          // });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(
                                                fromSignUp: false,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ref
                                                      .read(ProviderList
                                                          .profileProvider)
                                                      .userProfile
                                                      .firstName!
                                                      .isEmpty
                                                  ? const SetupProfileScreen()
                                                  : ref
                                                          .read(ProviderList
                                                              .workspaceProvider)
                                                          .workspaces
                                                          .isEmpty
                                                      ? const SetupWorkspace()
                                                      : const HomeScreen(
                                                          fromSignUp: false,
                                                        ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        (Platform.isIOS &&
                                    dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ==
                                        null) ||
                                (Platform.isAndroid &&
                                    dotenv.env['GOOGLE_CLIENT_ID'] == null)
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: CustomText(
                                        'or',
                                        type: FontStyle.smallText,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                        (Platform.isIOS &&
                                    dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ==
                                        null) ||
                                (Platform.isAndroid &&
                                    dotenv.env['GOOGLE_CLIENT_ID'] == null)
                            ? Container()
                            : (authProvider.googleAuthState == StateEnum.loading
                                ? SizedBox(
                                    width: width,
                                    child: Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineSpinFadeLoader,
                                          colors:
                                              themeProvider.isDarkThemeEnabled
                                                  ? [Colors.white]
                                                  : [Colors.black],
                                          strokeWidth: 1.0,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  )
                                : Button(
                                    text: 'Sign In with Google',
                                    widget: Image.asset(
                                        'assets/images/google-icon.png'),
                                    // SvgPicture.asset('assets/svg_images/google-icon.svg',),
                                    textColor: themeProvider.isDarkThemeEnabled
                                        ? Colors.white
                                        : Colors.black,
                                    filledButton: false,
                                    ontap: () async {
                                      // await GoogleSignInApi.logout();
                                      try {
                                        var user =
                                            await GoogleSignInApi.logIn();
                                        if (user == null) {
                                          CustomToast().showToast(context,
                                              'Something went wrong, please try again.');
                                          return;
                                        }
                                        GoogleSignInAuthentication googleAuth =
                                            await user.authentication;
                                        ref
                                            .watch(ProviderList.authProvider)
                                            .googleAuth(data: {
                                          "clientId": dotenv
                                              .env['GOOGLE_SERVER_CLIENT_ID'],
                                          "credential": googleAuth.idToken,
                                          "medium": "google"
                                        }, context: context).then((value) {
                                          if (authProvider.googleAuthState ==
                                                  StateEnum.success &&
                                              profileProvider.getProfileState ==
                                                  StateEnum.success) {
                                            if (profileProvider
                                                .userProfile.isOnboarded!) {
                                              Navigator.push(
                                                context,
                                                (MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(
                                                    fromSignUp: false,
                                                  ),
                                                )),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ref
                                                          .read(ProviderList
                                                              .profileProvider)
                                                          .userProfile
                                                          .firstName!
                                                          .isEmpty
                                                      ? const SetupProfileScreen()
                                                      : ref
                                                              .read(ProviderList
                                                                  .workspaceProvider)
                                                              .workspaces
                                                              .isEmpty
                                                          ? const SetupWorkspace()
                                                          : const HomeScreen(
                                                              fromSignUp: false,
                                                            ),
                                                ),
                                              );
                                            }
                                          }
                                        });
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    },
                                  )),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // Button(
                        //   text: 'Sign In with GitHub',
                        //   textColor: themeProvider.isDarkThemeEnabled
                        //       ? Colors.white
                        //       : Colors.black,
                        //   filledButton: false,
                        // ),

                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: greyColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  if (!sentCode) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  setState(() {
                                    code.clear();
                                    sentCode = false;
                                  });
                                },
                                child: const CustomText(
                                  'Go back',
                                  type: FontStyle.heading2,
                                  color: greyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateSave() {
    final form = gkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
