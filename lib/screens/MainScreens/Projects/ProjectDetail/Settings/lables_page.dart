import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/delete_labels_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/Settings/create_label.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';

import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class LablesPage extends ConsumerStatefulWidget {
  const LablesPage({super.key});

  @override
  ConsumerState<LablesPage> createState() => _LablesPageState();
}

class _LablesPageState extends ConsumerState<LablesPage> {
  List expanded = [];
  bool isChildAvailable(String id) {
    var issuesProv = ref.read(ProviderList.issuesProvider);
    for (var element in issuesProv.labels) {
      if (element["parent"] == id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    // log(ref.read(ProviderList.projectProvider).currentProject["id"]);
    return LoadingWidget(
      loading: issuesProvider.labelState == StateEnum.loading,
      widgetClass: Container(
        color: themeProvider.isDarkThemeEnabled
            ? darkSecondaryBackgroundDefaultColor
            : lightSecondaryBackgroundDefaultColor,
        child: issuesProvider.labels.isEmpty
            ? EmptyPlaceholder.emptyLabels(context)
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: issuesProvider.labels.length,
                itemBuilder: (context, index) {
                  var isChildAvail =
                      isChildAvailable(issuesProvider.labels[index]["id"]);
                  return issuesProvider.labels[index]["parent"] == null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkBackgroundColor
                                  : lightBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? Colors.transparent
                                      : strokeColor)),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        !isChildAvail
                                            ? CircleAvatar(
                                                radius: 6,
                                                backgroundColor: Color(int.parse(
                                                    '0xFF${issuesProvider.labels[index]['color'].toString().toUpperCase().replaceAll('#', '')}')),
                                              )
                                            : SvgPicture.asset(
                                                "assets/svg_images/label_group.svg",
                                                colorFilter: ColorFilter.mode(
                                                    Color(int.parse(
                                                        '0xFF${issuesProvider.labels[index]['color'].toString().toUpperCase().replaceAll('#', '')}')),
                                                    BlendMode.srcIn),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          issuesProvider.labels[index]['name'],
                                          type: FontStyle.heading2,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkSecondaryTextColor
                                                    : Colors.black,
                                          ),
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkBackgroundColor
                                                  : Colors.white,
                                          onSelected: (val) {
                                            if (val == 'EDIT') {
                                              showModalBottomSheet(
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.8,
                                                ),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: CreateLabel(
                                                      label: issuesProvider
                                                              .labels[index]
                                                          ['name'],
                                                      labelColor: issuesProvider
                                                              .labels[index]
                                                          ['color'],
                                                      labelId: issuesProvider
                                                          .labels[index]['id'],
                                                      method: CRUD.update,
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (val == 'CONVERT' ||
                                                val == 'ADD') {
                                              showModalBottomSheet(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.sizeOf(
                                                                    context)
                                                                .height *
                                                            0.8),
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return SingleLabelSelect(
                                                    labelID: issuesProvider
                                                        .labels[index]["id"],
                                                  );
                                                },
                                              );
                                            } else {
                                              showModalBottomSheet(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 300),
                                                enableDrag: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: DeleteLabelSheet(
                                                      labelName: issuesProvider
                                                              .labels[index]
                                                          ['name'],
                                                      labelId: issuesProvider
                                                          .labels[index]['id'],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (ctx) => [
                                            PopupMenuItem(
                                              value: 'CONVERT',
                                              child: Row(
                                                children: [
                                                  isChildAvail
                                                      ? Icon(
                                                          Icons.add,
                                                          size: 19,
                                                          color: themeProvider
                                                                  .isDarkThemeEnabled
                                                              ? darkSecondaryTextColor
                                                              : Colors.black,
                                                        )
                                                      : SvgPicture.asset(
                                                          "assets/svg_images/label_group.svg",
                                                          colorFilter: ColorFilter.mode(
                                                              themeProvider
                                                                      .isDarkThemeEnabled
                                                                  ? darkSecondaryTextColor
                                                                  : Colors
                                                                      .black,
                                                              BlendMode.srcIn),
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    isChildAvail
                                                        ? 'Add more labels'
                                                        : 'Convert to group',
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? darkSecondaryTextColor
                                                        : Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'EDIT',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    size: 19,
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? darkSecondaryTextColor
                                                        : Colors.black,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    'Edit Label',
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? darkSecondaryTextColor
                                                        : Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'DELETE',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    size: 19,
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? darkSecondaryTextColor
                                                        : Colors.black,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    'Delete Label',
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? darkSecondaryTextColor
                                                        : Colors.black,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        !isChildAvail
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      if (expanded
                                                          .contains(index)) {
                                                        expanded.remove(index);
                                                      } else {
                                                        expanded.add(index);
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: expanded
                                                            .contains(index)
                                                        ? Icon(
                                                            Icons
                                                                .keyboard_arrow_up,
                                                            color: themeProvider
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : Colors.black,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color: themeProvider
                                                                    .isDarkThemeEnabled
                                                                ? darkSecondaryTextColor
                                                                : Colors.black,
                                                          )),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                  children: expanded.contains(index)
                                      ? issuesProvider.labels
                                          .map(
                                            (e) =>
                                                e["parent"] ==
                                                        issuesProvider
                                                            .labels[index]["id"]
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            bottom: 15,
                                                            left: 15,
                                                            right: 15),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                top: 5,
                                                                bottom: 5),
                                                        decoration: BoxDecoration(
                                                            color: themeProvider
                                                                    .isDarkThemeEnabled
                                                                ? darkBackgroundColor
                                                                : lightBackgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: themeProvider
                                                                        .isDarkThemeEnabled
                                                                    ? darkThemeBorder
                                                                    : strokeColor)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 6,
                                                                  backgroundColor:
                                                                      Color(int
                                                                          .parse(
                                                                              '0xFF${e['color'].toString().toUpperCase().replaceAll('#', '')}')),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                CustomText(
                                                                  e['name'],
                                                                  type: FontStyle
                                                                      .heading2,
                                                                  maxLines: 3,
                                                                ),
                                                              ],
                                                            ),
                                                            PopupMenuButton(
                                                              icon: Icon(
                                                                Icons.more_vert,
                                                                color: themeProvider
                                                                        .isDarkThemeEnabled
                                                                    ? darkSecondaryTextColor
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                              color: themeProvider
                                                                      .isDarkThemeEnabled
                                                                  ? darkBackgroundColor
                                                                  : Colors
                                                                      .white,
                                                              onSelected:
                                                                  (val) {
                                                                if (val ==
                                                                    'EDIT') {
                                                                  showModalBottomSheet(
                                                                    enableDrag:
                                                                        true,
                                                                    isScrollControlled:
                                                                        true,
                                                                    constraints:
                                                                        BoxConstraints(
                                                                      maxHeight:
                                                                          MediaQuery.of(context).size.height *
                                                                              0.8,
                                                                    ),
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(20),
                                                                        topRight:
                                                                            Radius.circular(20),
                                                                      ),
                                                                    ),
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                        child:
                                                                            CreateLabel(
                                                                          label:
                                                                              e['name'],
                                                                          labelColor:
                                                                              e['color'],
                                                                          labelId:
                                                                              e['id'],
                                                                          method:
                                                                              CRUD.update,
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                } else if (val ==
                                                                    'CONVERT') {
                                                                  issuesProvider
                                                                      .issueLabels(
                                                                          slug: ref
                                                                              .watch(ProviderList
                                                                                  .workspaceProvider)
                                                                              .selectedWorkspace!
                                                                              .workspaceSlug,
                                                                          projID: ref.watch(ProviderList.projectProvider).currentProject[
                                                                              'id'],
                                                                          method: CRUD
                                                                              .update,
                                                                          data: {
                                                                            "parent":
                                                                                null,
                                                                          },
                                                                          labelId:
                                                                              e["id"]);
                                                                } else {
                                                                  showModalBottomSheet(
                                                                    constraints:
                                                                        const BoxConstraints(
                                                                            maxHeight:
                                                                                300),
                                                                    enableDrag:
                                                                        true,
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(20),
                                                                        topRight:
                                                                            Radius.circular(20),
                                                                      ),
                                                                    ),
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                        child:
                                                                            DeleteLabelSheet(
                                                                          labelName:
                                                                              e['name'],
                                                                          labelId:
                                                                              e['id'],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              itemBuilder:
                                                                  (ctx) => [
                                                                PopupMenuItem(
                                                                  value:
                                                                      'CONVERT',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            19,
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      CustomText(
                                                                        'Remove from group',
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  value: 'EDIT',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size:
                                                                            19,
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      CustomText(
                                                                        'Edit Label',
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                PopupMenuItem(
                                                                  value:
                                                                      'DELETE',
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            19,
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      CustomText(
                                                                        'Delete Label',
                                                                        color: themeProvider.isDarkThemeEnabled
                                                                            ? darkSecondaryTextColor
                                                                            : Colors.black,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                          )
                                          .toList()
                                      : [])
                            ],
                          ),
                        )
                      : Container();
                },
              ),
      ),
    );
  }
}

class SingleLabelSelect extends ConsumerStatefulWidget {
  const SingleLabelSelect({required this.labelID, super.key});
  final String labelID;
  @override
  ConsumerState<SingleLabelSelect> createState() => _SingleLabelSelectState();
}

class _SingleLabelSelectState extends ConsumerState<SingleLabelSelect> {
  double height = 0.0;
  bool isChildAvailable(String id) {
    var issuesProv = ref.read(ProviderList.issuesProvider);
    for (var element in issuesProv.labels) {
      if (element["parent"] == id) return true;
    }
    return false;
  }

  bool isLabelsAvailable({int index = 0, bool iterate = false}) {
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    if (iterate) {
      for (var element in issuesProvider.labels) {
        if (!(element["id"] == widget.labelID ||
            element["parent"] == widget.labelID ||
            element["parent"] != null ||
            isChildAvailable(element["id"]))) return false;
      }
      return true;
    }
    return issuesProvider.labels[index]["id"] == widget.labelID ||
        issuesProvider.labels[index]["parent"] == widget.labelID ||
        issuesProvider.labels[index]["parent"] != null ||
        isChildAvailable(issuesProvider.labels[index]["id"]);
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      'Select Labels',
                      type: FontStyle.heading,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Color.fromRGBO(143, 143, 147, 1),
                      ),
                    )
                  ],
                ),
                Container(height: 15),
                isLabelsAvailable(iterate: true)
                    ? EmptyPlaceholder.emptyLabels(context)
                    : ListView.builder(
                        itemCount: issuesProvider.labels.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return isLabelsAvailable(index: index)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    issuesProvider.issueLabels(
                                        slug: ref
                                            .watch(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace!
                                            .workspaceSlug,
                                        projID: ref
                                            .watch(ProviderList.projectProvider)
                                            .currentProject['id'],
                                        method: CRUD.update,
                                        data: {
                                          "parent": widget.labelID,
                                        },
                                        labelId: issuesProvider.labels[index]
                                            ["id"]);

                                    Navigator.pop(context);
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
                                            CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Color(
                                                int.parse(
                                                  "FF${issuesProvider.labels[index]['color'].toString().toUpperCase().replaceAll("#", "")}",
                                                  radix: 16,
                                                ),
                                              ),
                                            ),
                                            Container(width: 10),
                                            CustomText(
                                              issuesProvider.labels[index]
                                                      ['name']
                                                  .toString(),
                                              type: FontStyle.subheading,
                                            ),
                                            const Spacer(),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          height: 1,
                                          // margin: const EdgeInsets.only(bottom: 5),
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : strokeColor,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        }),
              ],
            ),
          ),
          issuesProvider.labelState == StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC.withOpacity(0.7)
                      : lightSecondaryBackgroundColor.withOpacity(0.7),
                  // height: 25,
                  // width: 25,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider.isDarkThemeEnabled
                              ? Colors.white
                              : Colors.black
                        ],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
