import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_active_card.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane_startup/widgets/custom_divider.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class CycleWidget extends ConsumerStatefulWidget {
  const CycleWidget({super.key});

  @override
  ConsumerState<CycleWidget> createState() => _CycleWidgetState();
}

class _CycleWidgetState extends ConsumerState<CycleWidget> {
  int cycleNaveBarSelectedIndex = 0;

  @override
  void initState() {
    // print("CYCLES");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return cyclesProvider.cyclesState == StateEnum.loading
        ? Center(
            child: SizedBox(
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
          )
        : cycles();
  }

  Widget cycles() {
    return SizedBox(
      width: width,
      height: height,
      child: Column(children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(height: 40, child: cycleNaveBar()),
        const SizedBox(
          height: 15,
        ),
        Expanded(child: cycleBody()),
      ]),
    );
  }

  Widget cycleNaveBar() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        const SizedBox(width: 16),
        cycleNaveBarItem('All', 0),
        cycleNaveBarItem('Active', 1),
        cycleNaveBarItem('Upcoming', 2),
        cycleNaveBarItem('Completed', 3),
        cycleNaveBarItem('Draft', 4),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget cycleNaveBarItem(String title, int itemIndex) {
    const Color textColorOnSelected = Colors.white;
    var themeProvider = ref.watch(ProviderList.themeProvider);

    BoxDecoration decarationOnSelected = BoxDecoration(
        border: Border.all(width: 1, color: Colors.blueAccent),
        color: Colors.blueAccent,
        borderRadius: const BorderRadius.all(Radius.circular(5)));
    BoxDecoration decarationOnUnSelected = BoxDecoration(
        border: Border.all(
            width: 1,
            color: themeProvider.isDarkThemeEnabled
                ? darkThemeBorder
                : Colors.grey.shade300),
        color: themeProvider.isDarkThemeEnabled
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(5)));
    return GestureDetector(
      onTap: () {
        setState(() {
          cycleNaveBarSelectedIndex = itemIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.only(
          right: 10,
        ),
        decoration: cycleNaveBarSelectedIndex == itemIndex
            ? decarationOnSelected
            : decarationOnUnSelected,
        child: CustomText(
          title,
          color: cycleNaveBarSelectedIndex == itemIndex
              ? textColorOnSelected
              : null,
          type: FontStyle.text,
        ),
      ),
    );
  }

  Widget cycleBody() {
    List<Widget> widgets = [
      cycleAll(),
      cycleActive(),
      cycleUpcoming(),
      cycleCompleted(),
      cycleDraft()
    ];
    return widgets[cycleNaveBarSelectedIndex];
  }

  Widget cycleAll() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.allCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesAllData.isEmpty &&
              cyclesProvider.cycleFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  cyclesProvider.cycleFavoriteData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cyclesProvider.cycleFavoriteData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProvider.currentCycle =
                                    cyclesProvider.cycleFavoriteData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cycleFavoriteData[index]['id'],
                                      cycleName: cyclesProvider
                                          .cycleFavoriteData[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cycleFavoriteData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              cyclesProvider.cycleFavoriteData[
                                                                  index]
                                                              ['start_date'] ==
                                                          null ||
                                                      cyclesProvider.cycleFavoriteData[
                                                                  index]
                                                              ['end_date'] ==
                                                          null
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: themeProvider
                                                                .isDarkThemeEnabled
                                                            ? greenWithOpacity
                                                            : lightGreeyColor,
                                                      ),
                                                      child: const CustomText(
                                                          'Draft'),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cycleFavoriteData[index][
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cycleFavoriteData[index]
                                                                          [
                                                                          'end_date']) ==
                                                                  'Completed'
                                                              ? primaryLightColor
                                                              : greenWithOpacity,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: CustomText(
                                                        checkDate(
                                                          startDate: cyclesProvider
                                                                  .cycleFavoriteData[
                                                              index]['start_date'],
                                                          endDate: cyclesProvider
                                                                  .cycleFavoriteData[
                                                              index]['end_date'],
                                                        ),
                                                        color: checkDate(
                                                                  startDate: cyclesProvider
                                                                              .cycleFavoriteData[
                                                                          index]
                                                                      [
                                                                      'start_date'],
                                                                  endDate: cyclesProvider
                                                                              .cycleFavoriteData[
                                                                          index]
                                                                      [
                                                                      'end_date'],
                                                                ) ==
                                                                'Draft'
                                                            ? greyColor
                                                            : checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cycleFavoriteData[index]
                                                                              [
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cycleFavoriteData[index]
                                                                          [
                                                                          'end_date'],
                                                                    ) ==
                                                                    'Completed'
                                                                ? primaryColor
                                                                : greenHighLight,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              String cycleId = cyclesProvider
                                                  .cycleFavoriteData[index]
                                                      ['id']
                                                  .toString();
                                              cyclesProvider.cyclesAllData.add(
                                                  cyclesProvider
                                                      .cycleFavoriteData[index]
                                                      .cast<String, dynamic>());
                                              cyclesProvider.cycleFavoriteData
                                                  .removeAt(index);
                                              cyclesProviderRead.setState();
                                              cyclesProvider.updateCycle(
                                                disableLoading: true,
                                                slug: ref
                                                    .read(ProviderList
                                                        .workspaceProvider)
                                                    .selectedWorkspace!
                                                    .workspaceSlug,
                                                projectId: ref
                                                    .read(ProviderList
                                                        .projectProvider)
                                                    .currentProject['id'],
                                                data: {
                                                  'cycle': cycleId,
                                                },
                                                query: 'all',
                                                cycleId: cycleId,
                                                isFavorite: true,
                                              );
                                            },
                                            child: const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleName: cyclesProvider
                                                            .cycleFavoriteData[
                                                        index]['name'],
                                                    cycleId: cyclesProvider
                                                            .cycleFavoriteData[
                                                        index]['id'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider)
                                ],
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                  // cyclesProvider.cycleFavoriteData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 20,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cyclesAllData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cyclesProvider.cyclesAllData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProvider.currentCycle =
                                    cyclesProvider.cyclesAllData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cyclesAllData[index]['id'],
                                      cycleName: cyclesProvider
                                          .cyclesAllData[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: (Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cyclesAllData[index]
                                                      ['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              cyclesProvider.cyclesAllData[
                                                                  index]
                                                              ['start_date'] ==
                                                          null ||
                                                      cyclesProvider.cyclesAllData[
                                                                  index]
                                                              ['end_date'] ==
                                                          null
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: themeProvider
                                                                .isDarkThemeEnabled
                                                            ? greenWithOpacity
                                                            : lightGreeyColor,
                                                      ),
                                                      child: const CustomText(
                                                          'Draft'),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cyclesAllData[index][
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cyclesAllData[index]
                                                                          [
                                                                          'end_date']) ==
                                                                  'Completed'
                                                              ? primaryLightColor
                                                              : greenWithOpacity,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: CustomText(
                                                        checkDate(
                                                          startDate: cyclesProvider
                                                                  .cyclesAllData[
                                                              index]['start_date'],
                                                          endDate: cyclesProvider
                                                                  .cyclesAllData[
                                                              index]['end_date'],
                                                        ),
                                                        color: checkDate(
                                                                  startDate: cyclesProvider
                                                                              .cyclesAllData[
                                                                          index]
                                                                      [
                                                                      'start_date'],
                                                                  endDate: cyclesProvider
                                                                              .cyclesAllData[
                                                                          index]
                                                                      [
                                                                      'end_date'],
                                                                ) ==
                                                                'Draft'
                                                            ? greyColor
                                                            : checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cyclesAllData[index]
                                                                              [
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cyclesAllData[index]
                                                                          [
                                                                          'end_date'],
                                                                    ) ==
                                                                    'Completed'
                                                                ? primaryColor
                                                                : greenHighLight,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                String cycleId = cyclesProvider
                                                    .cyclesAllData[index]['id'];
                                                cyclesProvider.cycleFavoriteData
                                                    .add(cyclesProvider
                                                        .cyclesAllData[index]);
                                                cyclesProvider.cyclesAllData
                                                    .removeAt(index);
                                                cyclesProviderRead.setState();
                                                cyclesProvider.updateCycle(
                                                    disableLoading: true,
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .selectedWorkspace!
                                                        .workspaceSlug,
                                                    projectId: ref
                                                        .read(ProviderList
                                                            .projectProvider)
                                                        .currentProject['id'],
                                                    cycleId: cycleId,
                                                    isFavorite: false,
                                                    query: 'all',
                                                    data: {
                                                      'cycle': cycleId,
                                                    });
                                              },
                                              child: Icon(
                                                Icons.star_border,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC,
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cyclesAllData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cyclesAllData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider)
                                ],
                              )),
                            );
                          })
                      : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

  Widget cycleActive() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    if (cyclesProvider.activeCyclesState == StateEnum.loading) {
      return const LoadingWidget(widgetClass: Center(), loading: true);
    } else if (cyclesProvider.cyclesActiveData.isEmpty) {
      return const SizedBox(
        child: Center(
          child: CustomText(
            'No active cycle is present.',
            type: FontStyle.subheading,
          ),
        ),
      );
    } else {
      return cyclesProvider.cyclesActiveData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context)
          : ListView.builder(
              itemCount: cyclesProvider.cyclesActiveData.length,
              itemBuilder: (context, index) {
                return CycleActiveCard(
                  index: index,
                );
              },
            );
    }
  }

  Widget cycleCompleted() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.completedCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesCompletedData.isEmpty &&
              cyclesProvider.cycleCompletedFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  // cyclesProvider.cycleCompletedFavoriteData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cycleCompletedFavoriteData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount:
                              cyclesProvider.cycleCompletedFavoriteData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle = cyclesProvider
                                    .cycleCompletedFavoriteData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                              .cycleCompletedFavoriteData[index]
                                          ['id'],
                                      cycleName: cyclesProvider
                                              .cycleCompletedFavoriteData[index]
                                          ['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cycleCompletedFavoriteData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: checkDate(
                                                                startDate: cyclesProvider
                                                                        .cycleCompletedFavoriteData[index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                        .cycleCompletedFavoriteData[index][
                                                                    'end_date']) ==
                                                            'Draft'
                                                        ? lightGreeyColor
                                                        : checkDate(
                                                                    startDate: cyclesProvider.cycleCompletedFavoriteData[index][
                                                                        'start_date'],
                                                                    endDate: cyclesProvider
                                                                            .cycleCompletedFavoriteData[index][
                                                                        'end_date']) ==
                                                                'Completed'
                                                            ? primaryLightColor
                                                            : greenWithOpacity,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                child: CustomText(
                                                  checkDate(
                                                    startDate: cyclesProvider
                                                            .cycleCompletedFavoriteData[
                                                        index]['start_date'],
                                                    endDate: cyclesProvider
                                                            .cycleCompletedFavoriteData[
                                                        index]['end_date'],
                                                  ),
                                                  color: checkDate(
                                                            startDate: cyclesProvider
                                                                        .cycleCompletedFavoriteData[
                                                                    index]
                                                                ['start_date'],
                                                            endDate: cyclesProvider
                                                                    .cycleCompletedFavoriteData[
                                                                index]['end_date'],
                                                          ) ==
                                                          'Draft'
                                                      ? greyColor
                                                      : checkDate(
                                                                startDate: cyclesProvider
                                                                            .cycleCompletedFavoriteData[
                                                                        index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                            .cycleCompletedFavoriteData[
                                                                        index][
                                                                    'end_date'],
                                                              ) ==
                                                              'Completed'
                                                          ? primaryColor
                                                          : greenHighLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              String cycleId = cyclesProvider
                                                  .cycleCompletedFavoriteData[
                                                      index]['id']
                                                  .toString();
                                              cyclesProvider.cyclesCompletedData
                                                  .add(cyclesProvider
                                                      .cycleCompletedFavoriteData[
                                                          index]
                                                      .cast<String, dynamic>());
                                              cyclesProvider
                                                  .cycleCompletedFavoriteData
                                                  .removeAt(index);
                                              cyclesProviderRead.setState();
                                              cyclesProvider.updateCycle(
                                                  disableLoading: true,
                                                  slug: ref
                                                      .read(ProviderList
                                                          .workspaceProvider)
                                                      .selectedWorkspace!
                                                      .workspaceSlug,
                                                  projectId: ref
                                                      .read(ProviderList
                                                          .projectProvider)
                                                      .currentProject['id'],
                                                  cycleId: cycleId,
                                                  isFavorite: true,
                                                  query: 'completed',
                                                  data: {
                                                    'cycle': cycleId,
                                                  });
                                            },
                                            child: const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cycleCompletedFavoriteData[
                                                        index]['id'],
                                                    cycleName: cyclesProviderRead
                                                            .cycleCompletedFavoriteData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider),
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                  // cyclesProvider.cyclesCompletedData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cyclesCompletedData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cyclesProvider.cyclesCompletedData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle =
                                    cyclesProvider.cyclesCompletedData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cyclesCompletedData[index]['id'],
                                      cycleName: cyclesProvider
                                          .cyclesCompletedData[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cyclesCompletedData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: checkDate(
                                                                startDate: cyclesProvider
                                                                        .cyclesCompletedData[index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                        .cyclesCompletedData[index][
                                                                    'end_date']) ==
                                                            'Draft'
                                                        ? lightGreeyColor
                                                        : checkDate(
                                                                    startDate: cyclesProvider.cyclesCompletedData[index][
                                                                        'start_date'],
                                                                    endDate: cyclesProvider
                                                                            .cyclesCompletedData[index][
                                                                        'end_date']) ==
                                                                'Completed'
                                                            ? primaryLightColor
                                                            : greenWithOpacity,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                child: CustomText(
                                                  checkDate(
                                                    startDate: cyclesProvider
                                                            .cyclesCompletedData[
                                                        index]['start_date'],
                                                    endDate: cyclesProvider
                                                            .cyclesCompletedData[
                                                        index]['end_date'],
                                                  ),
                                                  color: checkDate(
                                                            startDate: cyclesProvider
                                                                        .cyclesCompletedData[
                                                                    index]
                                                                ['start_date'],
                                                            endDate: cyclesProvider
                                                                    .cyclesCompletedData[
                                                                index]['end_date'],
                                                          ) ==
                                                          'Draft'
                                                      ? greyColor
                                                      : checkDate(
                                                                startDate: cyclesProvider
                                                                            .cyclesCompletedData[
                                                                        index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                            .cyclesCompletedData[
                                                                        index][
                                                                    'end_date'],
                                                              ) ==
                                                              'Completed'
                                                          ? primaryColor
                                                          : greenHighLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                String cycleId = cyclesProvider
                                                        .cyclesCompletedData[
                                                    index]['id'];
                                                cyclesProvider
                                                    .cycleCompletedFavoriteData
                                                    .add(cyclesProvider
                                                            .cyclesCompletedData[
                                                        index]);
                                                cyclesProvider
                                                    .cyclesCompletedData
                                                    .removeAt(index);
                                                cyclesProviderRead.setState();
                                                cyclesProviderRead.updateCycle(
                                                    disableLoading: true,
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .selectedWorkspace!
                                                        .workspaceSlug,
                                                    projectId: ref
                                                        .read(ProviderList
                                                            .projectProvider)
                                                        .currentProject['id'],
                                                    cycleId: cycleId,
                                                    isFavorite: false,
                                                    query: 'completed',
                                                    data: {
                                                      'cycle': cycleId,
                                                    });
                                              },
                                              child: Icon(
                                                Icons.star_border,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC,
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cyclesCompletedData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cyclesCompletedData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider),
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

  Widget cycleUpcoming() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.upcomingCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesUpcomingData.isEmpty &&
              cyclesProvider.cycleUpcomingFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  // cyclesProvider.cycleUpcomingFavoriteData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cycleUpcomingFavoriteData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount:
                              cyclesProvider.cycleUpcomingFavoriteData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle = cyclesProvider
                                    .cycleUpcomingFavoriteData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                              .cycleUpcomingFavoriteData[index]
                                          ['id'],
                                      cycleName: cyclesProvider
                                              .cycleUpcomingFavoriteData[index]
                                          ['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cycleUpcomingFavoriteData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: checkDate(
                                                                startDate: cyclesProvider
                                                                        .cycleUpcomingFavoriteData[index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                        .cycleUpcomingFavoriteData[index][
                                                                    'end_date']) ==
                                                            'Draft'
                                                        ? lightGreeyColor
                                                        : checkDate(
                                                                    startDate: cyclesProvider.cycleUpcomingFavoriteData[index][
                                                                        'start_date'],
                                                                    endDate: cyclesProvider
                                                                            .cycleUpcomingFavoriteData[index][
                                                                        'end_date']) ==
                                                                'Completed'
                                                            ? primaryLightColor
                                                            : greenWithOpacity,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                child: CustomText(
                                                  checkDate(
                                                    startDate: cyclesProvider
                                                            .cycleUpcomingFavoriteData[
                                                        index]['start_date'],
                                                    endDate: cyclesProvider
                                                            .cycleUpcomingFavoriteData[
                                                        index]['end_date'],
                                                  ),
                                                  color: checkDate(
                                                            startDate: cyclesProvider
                                                                        .cycleUpcomingFavoriteData[
                                                                    index]
                                                                ['start_date'],
                                                            endDate: cyclesProvider
                                                                    .cycleUpcomingFavoriteData[
                                                                index]['end_date'],
                                                          ) ==
                                                          'Draft'
                                                      ? greyColor
                                                      : checkDate(
                                                                startDate: cyclesProvider
                                                                            .cycleUpcomingFavoriteData[
                                                                        index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                            .cycleUpcomingFavoriteData[
                                                                        index][
                                                                    'end_date'],
                                                              ) ==
                                                              'Completed'
                                                          ? primaryColor
                                                          : greenHighLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              String cycleId = cyclesProvider
                                                  .cycleUpcomingFavoriteData[
                                                      index]['id']
                                                  .toString();
                                              cyclesProvider.cyclesUpcomingData
                                                  .add(cyclesProvider
                                                      .cycleUpcomingFavoriteData[
                                                          index]
                                                      .cast<String, dynamic>());
                                              cyclesProvider
                                                  .cycleUpcomingFavoriteData
                                                  .removeAt(index);
                                              cyclesProviderRead.setState();
                                              cyclesProvider.updateCycle(
                                                  disableLoading: true,
                                                  slug: ref
                                                      .read(ProviderList
                                                          .workspaceProvider)
                                                      .selectedWorkspace!
                                                      .workspaceSlug,
                                                  projectId: ref
                                                      .read(ProviderList
                                                          .projectProvider)
                                                      .currentProject['id'],
                                                  cycleId: cycleId,
                                                  isFavorite: true,
                                                  query: 'upcoming',
                                                  data: {
                                                    'cycle': cycleId,
                                                  });
                                            },
                                            child: const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cycleUpcomingFavoriteData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cycleUpcomingFavoriteData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider)
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                  // cyclesProvider.cyclesUpcomingData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cyclesUpcomingData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cyclesProvider.cyclesUpcomingData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle =
                                    cyclesProvider.cyclesUpcomingData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cyclesUpcomingData[index]['id'],
                                      cycleName: cyclesProvider
                                          .cyclesUpcomingData[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cyclesUpcomingData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: checkDate(
                                                                startDate: cyclesProvider
                                                                        .cyclesUpcomingData[index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                        .cyclesUpcomingData[index][
                                                                    'end_date']) ==
                                                            'Draft'
                                                        ? lightGreeyColor
                                                        : checkDate(
                                                                    startDate: cyclesProvider.cyclesUpcomingData[index][
                                                                        'start_date'],
                                                                    endDate: cyclesProvider
                                                                            .cyclesUpcomingData[index][
                                                                        'end_date']) ==
                                                                'Completed'
                                                            ? primaryLightColor
                                                            : greenWithOpacity,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                child: CustomText(
                                                  checkDate(
                                                    startDate: cyclesProvider
                                                            .cyclesUpcomingData[
                                                        index]['start_date'],
                                                    endDate: cyclesProvider
                                                            .cyclesUpcomingData[
                                                        index]['end_date'],
                                                  ),
                                                  color: checkDate(
                                                            startDate: cyclesProvider
                                                                        .cyclesUpcomingData[
                                                                    index]
                                                                ['start_date'],
                                                            endDate: cyclesProvider
                                                                    .cyclesUpcomingData[
                                                                index]['end_date'],
                                                          ) ==
                                                          'Draft'
                                                      ? greyColor
                                                      : checkDate(
                                                                startDate: cyclesProvider
                                                                            .cyclesUpcomingData[
                                                                        index][
                                                                    'start_date'],
                                                                endDate: cyclesProvider
                                                                            .cyclesUpcomingData[
                                                                        index][
                                                                    'end_date'],
                                                              ) ==
                                                              'Completed'
                                                          ? primaryColor
                                                          : greenHighLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              String cycleId = cyclesProvider
                                                      .cyclesUpcomingData[index]
                                                  ['id'];
                                              cyclesProvider
                                                  .cycleUpcomingFavoriteData
                                                  .add(cyclesProvider
                                                          .cyclesUpcomingData[
                                                      index]);
                                              cyclesProvider.cyclesUpcomingData
                                                  .removeAt(index);
                                              cyclesProviderRead.setState();
                                              cyclesProviderRead.updateCycle(
                                                  disableLoading: true,
                                                  slug: ref
                                                      .read(ProviderList
                                                          .workspaceProvider)
                                                      .selectedWorkspace!
                                                      .workspaceSlug,
                                                  projectId: ref
                                                      .read(ProviderList
                                                          .projectProvider)
                                                      .currentProject['id'],
                                                  cycleId: cycleId,
                                                  isFavorite: false,
                                                  query: 'upcoming',
                                                  data: {
                                                    'cycle': cycleId,
                                                  });
                                            },
                                            child: Icon(
                                              Icons.star_border,
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? lightSecondaryBackgroundColor
                                                  : darkSecondaryBGC,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cyclesUpcomingData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cyclesUpcomingData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider)
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

  Widget cycleDraft() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: cyclesProvider.draftCyclesState == StateEnum.loading,
      widgetClass: cyclesProvider.cyclesDraftData.isEmpty &&
              cyclesProvider.cycleDraftFavoriteData.isEmpty
          ? EmptyPlaceholder.emptyCycles(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  // cyclesProvider.cycleDraftFavoriteData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cycleDraftFavoriteData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount:
                              cyclesProvider.cycleDraftFavoriteData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle = cyclesProvider
                                    .cycleDraftFavoriteData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cycleDraftFavoriteData[index]['id'],
                                      cycleName: cyclesProvider
                                              .cycleDraftFavoriteData[index]
                                          ['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cycleDraftFavoriteData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              cyclesProvider.cycleDraftFavoriteData[
                                                                  index]
                                                              ['start_date'] ==
                                                          null ||
                                                      cyclesProvider.cycleDraftFavoriteData[
                                                                  index]
                                                              ['end_date'] ==
                                                          null
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: themeProvider
                                                                .isDarkThemeEnabled
                                                            ? greenWithOpacity
                                                            : lightGreeyColor,
                                                      ),
                                                      child: const CustomText(
                                                          'Draft'),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cycleDraftFavoriteData[index][
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cycleDraftFavoriteData[index]
                                                                          [
                                                                          'end_date']) ==
                                                                  'Completed'
                                                              ? primaryLightColor
                                                              : greenWithOpacity,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: CustomText(
                                                        checkDate(
                                                          startDate: cyclesProvider
                                                                  .cycleDraftFavoriteData[
                                                              index]['start_date'],
                                                          endDate: cyclesProvider
                                                                  .cycleDraftFavoriteData[
                                                              index]['end_date'],
                                                        ),
                                                        color: checkDate(
                                                                  startDate: cyclesProvider
                                                                              .cycleDraftFavoriteData[
                                                                          index]
                                                                      [
                                                                      'start_date'],
                                                                  endDate: cyclesProvider
                                                                              .cycleDraftFavoriteData[
                                                                          index]
                                                                      [
                                                                      'end_date'],
                                                                ) ==
                                                                'Draft'
                                                            ? greyColor
                                                            : checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cycleDraftFavoriteData[index]
                                                                              [
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cycleDraftFavoriteData[index]
                                                                          [
                                                                          'end_date'],
                                                                    ) ==
                                                                    'Completed'
                                                                ? primaryColor
                                                                : greenHighLight,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                String cycleId = cyclesProvider
                                                    .cycleFavoriteData[index]
                                                        ['id']
                                                    .toString();
                                                cyclesProvider.cyclesAllData
                                                    .add(cyclesProvider
                                                        .cycleFavoriteData[
                                                            index]
                                                        .cast<String,
                                                            dynamic>());
                                                cyclesProvider.cycleFavoriteData
                                                    .removeAt(index);
                                                cyclesProviderRead.setState();
                                                cyclesProvider.updateCycle(
                                                  disableLoading: true,
                                                  slug: ref
                                                      .read(ProviderList
                                                          .workspaceProvider)
                                                      .selectedWorkspace!
                                                      .workspaceSlug,
                                                  projectId: ref
                                                      .read(ProviderList
                                                          .projectProvider)
                                                      .currentProject['id'],
                                                  data: {
                                                    'cycle': cycleId,
                                                  },
                                                  query: 'all',
                                                  cycleId: cycleId,
                                                  isFavorite: true,
                                                );
                                              },
                                              child: cyclesProvider
                                                          .cycleDraftFavoriteData[
                                                      index]['is_favorite']
                                                  ? const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )
                                                  : Icon(
                                                      Icons.star_border,
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? lightSecondaryBackgroundColor
                                                          : darkSecondaryBGC,
                                                    )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cycleDraftFavoriteData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cycleDraftFavoriteData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider),
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                  // cyclesProvider.cyclesDraftData.isNotEmpty
                  //     ? const SizedBox(
                  //         height: 15,
                  //       )
                  //     : const SizedBox.shrink(),
                  cyclesProvider.cyclesDraftData.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cyclesProvider.cyclesDraftData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cyclesProviderRead.currentCycle =
                                    cyclesProvider.cyclesDraftData[index];
                                cyclesProviderRead.setState();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CycleDetail(
                                      cycleId: cyclesProvider
                                          .cyclesDraftData[index]['id'],
                                      cycleName: cyclesProvider
                                          .cyclesDraftData[index]['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg_images/cycles_icon.svg',
                                            height: 25,
                                            width: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.6,
                                                child: CustomText(
                                                  cyclesProvider
                                                          .cyclesDraftData[
                                                      index]['name'],
                                                  maxLines: 2,
                                                  type: FontStyle.heading2,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              cyclesProvider.cyclesDraftData[
                                                                  index]
                                                              ['start_date'] ==
                                                          null ||
                                                      cyclesProvider.cyclesDraftData[
                                                                  index]
                                                              ['end_date'] ==
                                                          null
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: themeProvider
                                                                .isDarkThemeEnabled
                                                            ? greenWithOpacity
                                                            : lightGreeyColor,
                                                      ),
                                                      child: const CustomText(
                                                          'Draft'),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cyclesDraftData[index][
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cyclesDraftData[index]
                                                                          [
                                                                          'end_date']) ==
                                                                  'Completed'
                                                              ? primaryLightColor
                                                              : greenWithOpacity,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: CustomText(
                                                        checkDate(
                                                          startDate: cyclesProvider
                                                                  .cyclesDraftData[
                                                              index]['start_date'],
                                                          endDate: cyclesProvider
                                                                  .cyclesDraftData[
                                                              index]['end_date'],
                                                        ),
                                                        color: checkDate(
                                                                  startDate: cyclesProvider
                                                                              .cyclesDraftData[
                                                                          index]
                                                                      [
                                                                      'start_date'],
                                                                  endDate: cyclesProvider
                                                                              .cyclesDraftData[
                                                                          index]
                                                                      [
                                                                      'end_date'],
                                                                ) ==
                                                                'Draft'
                                                            ? greyColor
                                                            : checkDate(
                                                                      startDate:
                                                                          cyclesProvider.cyclesDraftData[index]
                                                                              [
                                                                              'start_date'],
                                                                      endDate: cyclesProvider
                                                                              .cyclesDraftData[index]
                                                                          [
                                                                          'end_date'],
                                                                    ) ==
                                                                    'Completed'
                                                                ? primaryColor
                                                                : greenHighLight,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                await cyclesProvider.updateCycle(
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .selectedWorkspace!
                                                        .workspaceSlug,
                                                    projectId: ref
                                                        .read(ProviderList
                                                            .projectProvider)
                                                        .currentProject['id'],
                                                    cycleId: cyclesProvider
                                                            .cyclesAllData[
                                                        index]['id'],
                                                    isFavorite: false,
                                                    query: 'draft',
                                                    data: {
                                                      'cycle': cyclesProvider
                                                              .cyclesDraftData[
                                                          index]['id'],
                                                    });
                                                cyclesProviderRead.cyclesCrud(
                                                    slug: ref
                                                        .read(ProviderList
                                                            .workspaceProvider)
                                                        .selectedWorkspace!
                                                        .workspaceSlug,
                                                    projectId: ref
                                                        .read(ProviderList
                                                            .projectProvider)
                                                        .currentProject['id'],
                                                    method: CRUD.read,
                                                    query: 'draft');
                                              },
                                              child: cyclesProvider
                                                          .cyclesDraftData[
                                                      index]['is_favorite']
                                                  ? Icon(
                                                      Icons.star,
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? lightSecondaryBackgroundColor
                                                          : darkSecondaryBGC,
                                                    )
                                                  : Icon(
                                                      Icons.star_border,
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? lightSecondaryBackgroundColor
                                                          : darkSecondaryBGC,
                                                    )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.50),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (ctx) {
                                                  return DeleteCycleSheet(
                                                    cycleId: cyclesProvider
                                                            .cyclesDraftData[
                                                        index]['id'],
                                                    cycleName: cyclesProvider
                                                            .cyclesDraftData[
                                                        index]['name'],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.more_vert,
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? lightSecondaryBackgroundColor
                                                    : darkSecondaryBGC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  CustomDivider(themeProvider: themeProvider)
                                ],
                              ),
                            );
                          })
                      : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

  String checkDate({String? startDate, String? endDate}) {
    DateTime now = DateTime.now();
    if ((startDate == null) || (endDate == null)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        Duration difference = DateTime.parse(startDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        Duration difference = DateTime.parse(endDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      } else {
        return 'Completed';
      }
    }
  }
}
