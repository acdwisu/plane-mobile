import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class SelectProjectMembers extends ConsumerStatefulWidget {
  final bool createIssue;
  final String? issueId;

  const SelectProjectMembers(
      {this.issueId, required this.createIssue, super.key});

  @override
  ConsumerState<SelectProjectMembers> createState() =>
      _SelectProjectMembersState();
}

class _SelectProjectMembersState extends ConsumerState<SelectProjectMembers> {
  var selectedMembers = {};
  List<String> issueDetailSelectedMembers = [];

  @override
  void initState() {
    if (ref.read(ProviderList.issuesProvider).members.isEmpty) {
      ref.read(ProviderList.issuesProvider).getProjectMembers(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject['id']);
    }
    selectedMembers =
        ref.read(ProviderList.issuesProvider).createIssuedata['members'] ?? {};
    if (!widget.createIssue) getIssueMembers();
    super.initState();
  }

  getIssueMembers() {
    final issueProvider = ref.read(ProviderList.issueProvider);
    for (int i = 0;
        i < issueProvider.issueDetails['assignee_details'].length;
        i++) {
      issueDetailSelectedMembers
          .add(issueProvider.issueDetails['assignee_details'][i]['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var issueProvider = ref.read(ProviderList.issueProvider);
    var themeProvider = ref.read(ProviderList.themeProvider);
    return WillPopScope(
      onWillPop: () async {
        issuesProvider.createIssuedata['members'] =
            selectedMembers.isEmpty ? null : selectedMembers;
        issuesProvider.setsState();
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.isDarkThemeEnabled
              ? darkBackgroundColor
              : lightBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        // * 0.5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          'Select Members',
                          type: FontStyle.heading,
                        ),
                        IconButton(
                            onPressed: () {
                              issuesProvider.createIssuedata['members'] =
                                  selectedMembers.isEmpty
                                      ? null
                                      : selectedMembers;
                              issuesProvider.setsState();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                          itemCount: issuesProvider.members.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (widget.createIssue) {
                                  setState(() {
                                    if (selectedMembers[issuesProvider
                                            .members[index]['member']['id']] ==
                                        null) {
                                      selectedMembers[issuesProvider
                                          .members[index]['member']['id']] = {
                                        "name": issuesProvider.members[index]
                                                ['member']['first_name'] +
                                            " " +
                                            issuesProvider.members[index]
                                                ['member']['last_name'],
                                        "id": issuesProvider.members[index]
                                            ['member']['id']
                                      };
                                    } else {
                                      selectedMembers.remove(issuesProvider
                                          .members[index]['member']['id']);
                                    }
                                  });
                                } else {
                                  setState(() {
                                    if (issueDetailSelectedMembers.contains(
                                        issuesProvider.members[index]['member']
                                            ['id'])) {
                                      issueDetailSelectedMembers.remove(
                                          issuesProvider.members[index]
                                              ['member']['id']);
                                    } else {
                                      issueDetailSelectedMembers.add(
                                          issuesProvider.members[index]
                                              ['member']['id']);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                //height: 40,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),

                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                55, 65, 81, 1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          alignment: Alignment.center,
                                          child: CustomText(
                                            issuesProvider.members[index]
                                                    ['member']['email'][0]
                                                .toString()
                                                .toUpperCase(),
                                            type: FontStyle.subheading,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        CustomText(
                                          issuesProvider.members[index]
                                                  ['member']['first_name'] +
                                              " " +
                                              issuesProvider.members[index]
                                                  ['member']['last_name'],
                                          type: FontStyle.subheading,
                                        ),
                                        const Spacer(),
                                        widget.createIssue
                                            ? createIsseuSelectedMembersWidget(
                                                index)
                                            : issueDetailSelectedMembersWidget(
                                                index),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: width,
                                      height: 1,
                                      color: strokeColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(height: 30),
                  ],
                ),
              ),
            ),
            // !widget.createIssue
            //     ? Positioned(
            //         bottom: 0,
            //         right: 0,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                   backgroundColor: primaryColor),
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //                 issueProvider.upDateIssue(
            //                     slug: ref
            //                         .read(ProviderList.workspaceProvider)
            //                         .selectedWorkspace!
            //                         .workspaceSlug,
            //                     projID: ref
            //                         .read(ProviderList.projectProvider)
            //                         .currentProject['id'],
            //                     issueID: widget.issueId!,
            //                     index: widget.index!,
            //                     ref: ref,
            //                     data: {
            //                       "assignees_list": issueDetailSelectedMembers
            //                     }).then(
            //                   (value) {
            //                     ref
            //                         .read(ProviderList.issueProvider)
            //                         .getIssueDetails(
            //                             slug: ref
            //                                 .read(
            //                                     ProviderList.workspaceProvider)
            //                                 .selectedWorkspace!
            //                                 .workspaceSlug,
            //                             projID: ref
            //                                 .read(ProviderList.projectProvider)
            //                                 .currentProject['id'],
            //                             issueID: widget.issueId!)
            //                         .then(
            //                           (value) => ref
            //                               .read(ProviderList.issueProvider)
            //                               .getIssueActivity(
            //                                 slug: ref
            //                                     .read(ProviderList
            //                                         .workspaceProvider)
            //                                     .selectedWorkspace!
            //                                     .workspaceSlug,
            //                                 projID: ref
            //                                     .read(ProviderList
            //                                         .projectProvider)
            //                                     .currentProject['id'],
            //                                 issueID: widget.issueId!,
            //                               ),
            //                         );
            //                   },
            //                 );
            //               },
            //               child: const CustomText(
            //                 'Add',
            //                 type: FontStyle.buttonText,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     : Container(),
            issuesProvider.membersState == StateEnum.loading
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                    // height: 25,
                    // width: 25,
                    child: const Wrap(
                      children: [
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [Colors.black],
                            strokeWidth: 1.0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Column(
              children: [
                Expanded(child: Container()),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 50,
                  child: Button(
                    text: 'Select',
                    ontap: () {
                      if (!widget.createIssue) {
                        // Navigator.of(context).pop();
                        issueProvider.upDateIssue(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject['id'],
                            issueID: widget.issueId!,
                          
                            refs: ref,
                            data: {
                              "assignees_list": issueDetailSelectedMembers
                            });
                        //     .then(
                        //   (value) {
                        //     log('Then called');
                        //     ref
                        //         .read(ProviderList.issueProvider)
                        //         .getIssueDetails(
                        //             slug: ref
                        //                 .read(ProviderList.workspaceProvider)
                        //                 .selectedWorkspace!
                        //                 .workspaceSlug,
                        //             projID: ref
                        //                 .read(ProviderList.projectProvider)
                        //                 .currentProject['id'],
                        //             issueID: widget.issueId!)
                        //         .then((value) {
                        //       // ref
                        //       //     .read(ProviderList.issueProvider)
                        //       //     .getIssueActivity(
                        //       //       slug: ref
                        //       //           .read(ProviderList.workspaceProvider)
                        //       //           .selectedWorkspace!
                        //       //           .workspaceSlug,
                        //       //       projID: ref
                        //       //           .read(ProviderList.projectProvider)
                        //       //           .currentProject['id'],
                        //       //       issueID: widget.issueId!,
                        //       //     );

                        //       ref
                        //           .read(ProviderList.myIssuesProvider)
                        //           .getMyIssues(
                        //             slug: ref
                        //                 .read(ProviderList.workspaceProvider)
                        //                 .selectedWorkspace!
                        //                 .workspaceSlug,
                        //           );
                        //     });
                        //   },
                        // );
                        Navigator.of(context).pop();
                      } else {
                        issuesProvider.createIssuedata['members'] =
                            selectedMembers.isEmpty ? null : selectedMembers;
                        issuesProvider.setsState();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createIsseuSelectedMembersWidget(int idx) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return selectedMembers[issuesProvider.members[idx]['member']['id']] != null
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailSelectedMembersWidget(int idx) {
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    return issueDetailSelectedMembers
            .contains(issuesProvider.members[idx]['member']['id'])
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
