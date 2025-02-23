import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../../../../../bottom_sheets/filter_sheet.dart';
import '../../../../../bottom_sheets/type_sheet.dart';
import '../../../../../bottom_sheets/views_sheet.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/enums.dart';
import '../../../../../widgets/custom_text.dart';
import '../IssuesTab/create_issue.dart';

class ViewsDetail extends ConsumerStatefulWidget {
  const ViewsDetail({required this.index, super.key});
  final int index;
  @override
  ConsumerState<ViewsDetail> createState() => _ViewsDetailState();
}

class _ViewsDetailState extends ConsumerState<ViewsDetail> {
  var filtersData = {};
  var issuesData = {};
  int countFilters() {
    var prov = ref.read(ProviderList.viewsProvider);
    int count = 0;
    prov.views[widget.index]["query_data"].forEach((key, value) {
      if (value != null && value.isNotEmpty) count++;
    });
    return count;
  }

  @override
  void initState() {
    var issuesProv = ref.read(ProviderList.issuesProvider);
    var viewsProv = ref.read(ProviderList.viewsProvider);
    issuesProv.orderByState = StateEnum.loading;
    filtersData = Filters.toJson(issuesProv.issues.filters);
    issuesData = json.decode(json.encode(issuesProv.groupByResponse));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ProviderList.projectProvider).initializeProject(
          filters:
              Filters.fromJson(viewsProv.views[widget.index]["query_data"]));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var viewsProv = ref.watch(ProviderList.viewsProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
          onPressed: () {
            issuesProvider.issues.filters = Filters.fromJson(filtersData);
            issuesProvider.groupByResponse = issuesData;
            issuesProvider.isISsuesEmpty = issuesData.isEmpty;
            issuesProvider.setsState();

            Navigator.pop(context);
          },
          text: projectProvider.currentProject['name']),
      body: WillPopScope(
        onWillPop: () async {
          issuesProvider.issues.filters = Filters.fromJson(filtersData);
          issuesProvider.groupByResponse = issuesData;
          issuesProvider.isISsuesEmpty = issuesData.isEmpty;
          issuesProvider.setsState();
          return true;
        },
        child: LoadingWidget(
          loading: issuesProvider.issuePropertyState == StateEnum.loading ||
              issuesProvider.issueState == StateEnum.loading ||
              issuesProvider.statesState == StateEnum.loading ||
              issuesProvider.projectViewState == StateEnum.loading ||
              issuesProvider.orderByState == StateEnum.loading,
          widgetClass: Column(
            children: [
              Container(
                color: themeProvider.isDarkThemeEnabled
                    ? darkBackgroundColor
                    : Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 120,
                          child: CustomText(
                            viewsProv.views[widget.index]['name'],
                            type: FontStyle.heading,
                          ),
                        ),
                        const Spacer(),
                        const CustomText(
                          'Update',
                          color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: themeProvider.isDarkThemeEnabled
                              ? darkThemeBorder
                              : const Color.fromRGBO(250, 250, 250, 1),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: themeProvider.isDarkThemeEnabled
                                  ? Colors.transparent
                                  : strokeColor)),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CustomText(
                            '# Filters : ${countFilters()}',
                            color: greyColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.close,
                            color: greyColor,
                            size: 17,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 2,
                color: themeProvider.isDarkThemeEnabled
                    ? darkThemeBorder
                    : strokeColor,
                width: double.infinity,
              ),
              Expanded(child: issues(context, ref)),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: darkBackgroundColor,
                child: Row(
                  children: [
                    projectProvider.role == Role.admin
                        ? Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CreateIssue(),
                                  ),
                                );
                              },
                              child: const SizedBox.expand(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    CustomText(
                                      ' Issue',
                                      type: FontStyle.subtitle,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      height: 50,
                      width: 0.5,
                      color: greyColor,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints:
                                BoxConstraints(maxHeight: height * 0.5),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                            context: context,
                            builder: (ctx) {
                              return const TypeSheet(
                                issueCategory: IssueCategory.issues,
                              );
                            });
                      },
                      child: const SizedBox.expand(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 19,
                            ),
                            CustomText(
                              ' Layout',
                              type: FontStyle.subtitle,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                    Container(
                      height: 50,
                      width: 0.5,
                      color: greyColor,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.9),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                            context: context,
                            builder: (ctx) {
                              return const ViewsSheet(
                                issueCategory: IssueCategory.issues,
                              );
                            });
                      },
                      child: const SizedBox.expand(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_sidebar,
                              color: Colors.white,
                              size: 19,
                            ),
                            CustomText(
                              ' Views',
                              type: FontStyle.subtitle,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                    Container(
                      height: 50,
                      width: 0.5,
                      color: greyColor,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.85),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )),
                            context: context,
                            builder: (ctx) {
                              return FilterSheet(
                                issueCategory: IssueCategory.issues,
                              );
                            });
                      },
                      child: const SizedBox.expand(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                              size: 19,
                            ),
                            CustomText(
                              ' Filters',
                              type: FontStyle.subtitle,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
