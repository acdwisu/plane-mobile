import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/filter_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class CreateView extends ConsumerStatefulWidget {
  const CreateView({super.key});

  @override
  ConsumerState<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends ConsumerState<CreateView> {
  var filtersData = {
    'Filters': {
      "assignees": [],
      "created_by": [],
      "labels": [],
      "priority": [],
      "state": []
    }
  };

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  var filterKeys = [
    'Assignees:',
    'Created By:',
    'Labels:',
    'Priority:',
    'State:'
  ];
  Map priorities = {
    'urgent': {
      'icon': Icons.error_outline_rounded,
      'text': 'urgent',
      'color': const Color.fromRGBO(239, 68, 68, 1)
    },
    'high': {
      'icon': Icons.signal_cellular_alt,
      'text': 'high',
      'color': const Color.fromRGBO(249, 115, 22, 1)
    },
    'medium': {
      'icon': Icons.signal_cellular_alt_2_bar,
      'text': 'medium',
      'color': const Color.fromRGBO(234, 179, 8, 1)
    },
    'low': {
      'icon': Icons.signal_cellular_alt_1_bar,
      'text': 'low',
      'color': const Color.fromRGBO(34, 197, 94, 1)
    },
    'none': {
      'icon': Icons.do_disturb_alt_outlined,
      'text': 'none',
      'color': darkBackgroundColor
    }
  };
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var viewsProvider = ref.watch(ProviderList.viewsProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Scaffold(
      backgroundColor:
          themeProvider.isDarkThemeEnabled ? darkSecondaryBGC : Colors.white,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Create View',
      ),
      body: LoadingWidget(
        loading: viewsProvider.viewsState == StateEnum.loading,
        widgetClass: LayoutBuilder(builder: (ctx, constraints) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //form conatining title and description
                            const Row(
                              children: [
                                // Text(
                                //   'View Title',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w400,
                                //     color: themeProvider.secondaryTextColor,
                                //   ),
                                // ),
                                CustomText(
                                  'Title',
                                  type: FontStyle.title,
                                  // color: themeProvider.secondaryTextColor,
                                ),
                                // const Text(
                                //   ' *',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w400,
                                //     color: Colors.red,
                                //   ),
                                // ),
                                CustomText(
                                  ' *',
                                  type: FontStyle.title,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: title,
                              decoration: kTextFieldDecoration.copyWith(
                                fillColor: themeProvider.isDarkThemeEnabled
                                    ? darkBackgroundColor
                                    : lightBackgroundColor,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Text(
                            //   'Description',
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w400,
                            //     color: themeProvider.secondaryTextColor,
                            //   ),
                            // ),
                            const CustomText(
                              'Description',
                              type: FontStyle.title,
                              // color: themeProvider.secondaryTextColor,
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              maxLines: 6,
                              controller: description,
                              decoration: kTextFieldDecoration.copyWith(
                                fillColor: themeProvider.isDarkThemeEnabled
                                    ? darkBackgroundColor
                                    : lightBackgroundColor,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 30),

                            //container containing a plus icon and text add filter
                            GestureDetector(
                              onTap: () async {
                                await showModalBottomSheet(
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.85),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    )),
                                    context: context,
                                    builder: (ctx) {
                                      return FilterSheet(
                                        filtersData: filtersData,
                                        issueCategory: IssueCategory.issues,
                                        fromCreateView: true,
                                      );
                                    });
                                setState(() {
                                  log(filtersData.toString());
                                });
                              },
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkBackgroundColor
                                      : lightBackgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : strokeColor,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.add,
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : lightSecondaryTextColor,
                                    ),
                                    const SizedBox(width: 10),
                                    // const Text(
                                    //   'Add Filter',
                                    //   style: TextStyle(
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.w400,
                                    //     color: Color.fromRGBO(65, 65, 65, 1),
                                    //   ),
                                    // ),
                                    const CustomText(
                                      'Add Filter',
                                      type: FontStyle.title,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                                itemCount: filtersData['Filters']!.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: ((context, index) => filtersData[
                                            'Filters']!
                                        .values
                                        .elementAt(index)
                                        .isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 10,
                                            right: 10),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkBackgroundColor
                                                    : const Color.fromRGBO(
                                                        250, 250, 250, 1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? Colors.transparent
                                                    : strokeColor)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              filterKeys[index],
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Wrap(
                                              children: ((filtersData['Filters']
                                                          as Map)
                                                      .values
                                                      .elementAt(index) as List)
                                                  .map((e) => filterKeys[
                                                              index] ==
                                                          'Priority:'
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            ((filtersData['Filters']
                                                                        as Map)
                                                                    .values
                                                                    .elementAt(
                                                                        index) as List)
                                                                .remove(e);
                                                            setState(() {});
                                                          },
                                                          child: filterWidget(
                                                            color: priorities[e]
                                                                ['color'],
                                                            icon: Icon(
                                                              priorities[e]
                                                                  ['icon'],
                                                              size: 15,
                                                              color:
                                                                  priorities[e]
                                                                      ['color'],
                                                            ),
                                                            text: priorities[e]
                                                                ['text'],
                                                          ),
                                                        )
                                                      : filterKeys[index] ==
                                                              'State:'
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                ((filtersData['Filters']
                                                                            as Map)
                                                                        .values
                                                                        .elementAt(
                                                                            index) as List)
                                                                    .remove(e);
                                                                setState(() {});
                                                              },
                                                              child:
                                                                  filterWidget(
                                                                color: Color(
                                                                    int.parse(
                                                                        "FF${issuesProvider.states[e]['color'].toString().replaceAll('#', '')}",
                                                                        radix:
                                                                            16)),
                                                                icon: SizedBox(
                                                                    height: 15,
                                                                    width: 15,
                                                                    child: issuesProvider
                                                                        .stateIcons[e]),
                                                                text: issuesProvider
                                                                        .states[
                                                                    e]['name'],
                                                              ),
                                                            )
                                                          : filterKeys[index] ==
                                                                      'Assignees:' ||
                                                                  filterKeys[
                                                                          index] ==
                                                                      'Created By:'
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    ((filtersData['Filters']
                                                                                as Map)
                                                                            .values
                                                                            .elementAt(index) as List)
                                                                        .remove(e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      filterWidget(
                                                                    fill: false,
                                                                    color: Colors
                                                                        .black,
                                                                    icon: projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['avatar'] !=
                                                                            ''
                                                                        ? CircleAvatar(
                                                                            radius:
                                                                                10,
                                                                            backgroundImage:
                                                                                NetworkImage(projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['avatar']),
                                                                          )
                                                                        : CircleAvatar(
                                                                            radius:
                                                                                10,
                                                                            backgroundColor: const Color.fromRGBO(
                                                                                55,
                                                                                65,
                                                                                81,
                                                                                1),
                                                                            child: Center(
                                                                                child: CustomText(
                                                                              projectProvider.projectMembers.where((element) => element['member']["id"] == e).first['member']['email'][0].toString().toUpperCase(),
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                    text: projectProvider
                                                                            .projectMembers
                                                                            .where((element) =>
                                                                                element['member']["id"] ==
                                                                                e)
                                                                            .first['member']['first_name'] ??
                                                                        'aasdas',
                                                                  ),
                                                                )
                                                              : filterKeys[
                                                                          index] ==
                                                                      'Labels:'
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        ((filtersData['Filters'] as Map).values.elementAt(index)
                                                                                as List)
                                                                            .remove(e);
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: filterWidget(
                                                                          color: Color(int.parse("0xFF${issuesProvider.labels.where((element) => element["id"] == e).first['color'].toString().toUpperCase().replaceAll("#", "")}")),
                                                                          icon: Container(
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              color: Color(int.parse("0xFF${issuesProvider.labels.where((element) => element["id"] == e).first['color'].toString().toUpperCase().replaceAll("#", "")}")),
                                                                            ),
                                                                          ),
                                                                          text: issuesProvider.labels.where((element) => element["id"] == e).first["name"]),
                                                                    )
                                                                  : Container())
                                                  .toList(),
                                            ),
                                          ],
                                        ))
                                    : const SizedBox()))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Button(
                          text: 'Create View',
                          ontap: () async {
                            try {
                              
                              setState(() {
                                loading = true;
                              });
                              await ref
                                  .read(ProviderList.viewsProvider.notifier)
                                  .createViews(data: {
                                "name": title.text,
                                "description": description.text,
                                "query": {
                                  "assignees":
                                      filtersData["Filters"]!["assignees"],
                                  "created_by":
                                      filtersData["Filters"]!["created_by"],
                                  "labels": filtersData["Filters"]!["labels"],
                                  "priority":
                                      filtersData["Filters"]!["priority"],
                                  "state": filtersData["Filters"]!["state"]
                                },
                                "query_data": {
                                  "assignees":
                                      filtersData["Filters"]!["assignees"],
                                  "created_by":
                                      filtersData["Filters"]!["created_by"],
                                  "labels": filtersData["Filters"]!["labels"],
                                  "priority":
                                      filtersData["Filters"]!["priority"],
                                  "state": filtersData["Filters"]!["state"]
                                }
                              });
                              setState(() {
                                loading = false;
                              });
                              ref
                                  .read(ProviderList.viewsProvider.notifier)
                                  .getViews();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } catch (err) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Something went wrong!')));
                            }
                          },
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                loading
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 150),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkThemeEnabled
                              ? Colors.black.withOpacity(0.1)
                              : Colors.white.withOpacity(0.1),
                        ),
                        height: height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  colors: themeProvider.isDarkThemeEnabled
                                      ? [Colors.white]
                                      : [Colors.black],
                                  strokeWidth: 1.0,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // Text(
                              //   'processing...',
                              //   style: TextStylingWidget.smallText,
                              // )
                              const CustomText(
                                'Loading...',
                                type: FontStyle.subtitle,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget filterWidget({
    required Widget icon,
    required String text,
    bool fill = true,
    Color? color,
  }) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: themeProvider.isDarkThemeEnabled
                ? darkThemeBorder
                : Colors.grey.shade300),
        // color: fill
        //     ? (color != null ? color.withOpacity(0.2) : Colors.white)
        //     : null
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          CustomText(
            text.isNotEmpty
                ? text.replaceFirst(text[0], text[0].toUpperCase())
                : text,
            color: (themeProvider.isDarkThemeEnabled
                ? Colors.grey.shade500
                : greyColor),
            fontSize: 15,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
