// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/home_screen.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../utils/constants.dart';
import '../../../utils/random_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class JoinWorkspaces extends ConsumerStatefulWidget {
  final bool fromOnboard;
  const JoinWorkspaces(
      {required this.fromOnboard, super.key});

  @override
  ConsumerState<JoinWorkspaces> createState() => _JoinWorkspacesState();
}

class _JoinWorkspacesState extends ConsumerState<JoinWorkspaces> {
  List selectedWorkspaces = [];

  @override
  void initState() {
    ref.read(ProviderList.workspaceProvider).getWorkspaceInvitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    return Scaffold(
      appBar: !widget.fromOnboard
          ? CustomAppBar(
              text: 'Workspace invites',
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      body: SafeArea(
        child: LoadingWidget(
          loading: prov.workspaceInvitationState == StateEnum.loading ||
              prov.joinWorkspaceState == StateEnum.loading,
          widgetClass: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.fromOnboard
                      ? SvgPicture.asset('assets/svg_images/logo.svg')
                      : Container(),
                  widget.fromOnboard
                      ? const SizedBox(
                          height: 30,
                        )
                      : Container(),
                  widget.fromOnboard
                      ? const CustomText(
                          'Join Workspaces',
                          type: FontStyle.heading,
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: prov.workspaceInvitations.isEmpty
                        ? Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const CustomText(
                                'Currently you have no invited workspaces to join.',
                                type: FontStyle.description,
                                color: greyColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: prov.workspaceInvitations.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedWorkspaces.contains(prov
                                        .workspaceInvitations[index]['id'])) {
                                      selectedWorkspaces.remove(prov
                                          .workspaceInvitations[index]['id']);
                                    } else {
                                      selectedWorkspaces.add(prov
                                          .workspaceInvitations[index]['id']);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: prov.workspaceInvitations[
                                                                  index]
                                                              ['workspace']
                                                          ['logo'] ==
                                                      null
                                                  ? RandomColors()
                                                      .getRandomColor()
                                                  : Colors.white,
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            // padding: const EdgeInsets.symmetric(
                                            //     horizontal: 15, vertical: 10),
                                            child:
                                                prov.workspaceInvitations[index]
                                                                ['workspace']
                                                            ['logo'] ==
                                                        null
                                                    ? Center(
                                                        child: CustomText(
                                                          prov.workspaceInvitations[
                                                                  index]
                                                                  ['workspace']
                                                                  ['name']
                                                              .toString()
                                                              .toUpperCase()
                                                              .substring(0, 1),
                                                          type: FontStyle.title,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Image.network(
                                                          prov.workspaceInvitations[
                                                                  index]
                                                                  ['workspace']
                                                                  ['logo']
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                prov.workspaceInvitations[index]
                                                    ['workspace']['name'],
                                                type: FontStyle.title,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              const CustomText(
                                                'Invited',
                                                type: FontStyle.subtitle,
                                                color: greyColor,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      selectedWorkspaces.contains(
                                              prov.workspaceInvitations[index]
                                                  ['id'])
                                          ? const Icon(
                                              Icons.check_circle,
                                              size: 24,
                                              color: primaryColor,
                                            )
                                          : const Icon(
                                              Icons.check_circle_outline,
                                              color: greyColor,
                                            )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  // selectedWorkspaces.isEmpty
                  //     ? Container()
                  //     : Button(
                  //         ontap: () async {
                  //           var data = [];
                  //           for (var element in selectedWorkspaces) {
                  //             data.add(
                  //                 prov.workspaceInvitations[element]['id']);
                  //           }
                  //           await prov.joinWorkspaces(data: data);
                  //           for (var element in selectedWorkspaces) {
                  //             prov.workspaceInvitations.removeAt(element);
                  //           }
                  //           selectedWorkspaces.clear();
                  //           // ignore: use_build_context_synchronously
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => const HomeScreen(),
                  //             ),
                  //           );
                  //         },
                  //         text: 'Join',
                  //       ),
                  const SizedBox(
                    height: 20,
                  ),
                  selectedWorkspaces.isNotEmpty
                      ? Button(
                          text: 'Accept & join',
                          ontap: () async {
                            if (selectedWorkspaces.isNotEmpty) {
                              await prov.joinWorkspaces(
                                  data: selectedWorkspaces);
                              selectedWorkspaces.clear();
                              if (widget.fromOnboard) {
                                prov.ref!
                                    .read(ProviderList.profileProvider)
                                    .updateIsOnBoarded(val: true);
                                await profileProvider.updateProfile(data: {
                                  'onboarding_step': {
                                    "workspace_join": true,
                                    "profile_complete": true,
                                    "workspace_create": true,
                                    "workspace_invite": true
                                  }
                                });
                                await ref
                                    .read(ProviderList.workspaceProvider)
                                    .getWorkspaces();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(
                                      fromSignUp: true,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            } else {
                              CustomToast().showToast(context,
                                  'Please select atleast one workspace');
                            }
                          },
                        )
                      : Container(),
                  widget.fromOnboard
                      ? const SizedBox(
                          height: 20,
                        )
                      : Container(),
                  widget.fromOnboard
                      ? Button(
                          ontap: () {
                            Navigator.of(context).pop();
                          },
                          widget: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back,
                              color: greyColor,
                              size: 20,
                            ),
                          ),
                          text: 'Go back',
                          filledButton: false,
                          removeStroke: true,
                          textColor: greyColor,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
