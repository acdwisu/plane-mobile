import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/bottom_sheets/create_estimate.dart';
import 'package:plane_startup/bottom_sheets/delete_estimate_sheet.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class EstimatsPage extends ConsumerStatefulWidget {
  const EstimatsPage({super.key});

  @override
  ConsumerState<EstimatsPage> createState() => _EstimatsPageState();
}

class _EstimatsPageState extends ConsumerState<EstimatsPage> {
  @override
  void initState() {
    log(ref.read(ProviderList.projectProvider).currentProject.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);

    return LoadingWidget(
      loading: (projectProvider.updateProjectState == StateEnum.loading ||
          estimatesProvider.estimateState == StateEnum.loading),
      widgetClass: Container(
        width: MediaQuery.of(context).size.width,
        color: themeProvider.isDarkThemeEnabled
            ? darkSecondaryBackgroundDefaultColor
            : lightSecondaryBackgroundDefaultColor,
        child: estimatesProvider.estimates.isEmpty
            ? const EmptyEstimatesWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      log('update project');
                      projectProvider.updateProject(
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projId: projectProvider.currentProject['id'],
                        data: {'estimate': null},
                      ).then((_) {
                        projectProvider.currentProject['estimate'] = null;
                        projectProvider.setState();
                      });
                    },
                    child: Container(
                      height: 33,
                      margin: const EdgeInsets.only(right: 16, top: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkBackgroundColor
                            : lightBackgroundColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const CustomText('Disable Estimate',
                          type: FontStyle.subtitle),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: estimatesProvider.estimates.length,
                    itemBuilder: (context, index) {
                      String est = '';
                      for (int i = 0; i < 6; i++) {
                        est +=
                            '${estimatesProvider.estimates[index]['points'][i]['value']}';
                        if (i != 5) {
                          est += ', ';
                        }
                      }
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(16),
                        margin:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkThemeEnabled
                              ? darkBackgroundColor
                              : lightBackgroundColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkThemeBorder
                                  : strokeColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  estimatesProvider.estimates[index]['name'],
                                  textAlign: TextAlign.left,
                                  type: FontStyle.appbarTitle,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log('update project');
                                        projectProvider.updateProject(
                                          slug: ref
                                              .read(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projId: projectProvider
                                              .currentProject['id'],
                                          data: {
                                            'estimate': estimatesProvider
                                                .estimates[index]['id']
                                          },
                                        ).then((_) {
                                          projectProvider
                                                  .currentProject['estimate'] =
                                              estimatesProvider.estimates[index]
                                                  ['id'];
                                          projectProvider.setState();
                                        });
                                      },
                                      child: Container(
                                        height: 33,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: projectProvider.currentProject[
                                                      'estimate'] ==
                                                  estimatesProvider
                                                      .estimates[index]['id']
                                              ? greenWithOpacity
                                              : Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: projectProvider
                                                          .currentProject[
                                                      'estimate'] ==
                                                  estimatesProvider
                                                      .estimates[index]['id']
                                              ? null
                                              : Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                        ),
                                        child: CustomText(
                                            projectProvider.currentProject[
                                                        'estimate'] ==
                                                    estimatesProvider
                                                        .estimates[index]['id']
                                                ? 'In Use'
                                                : 'Use',
                                            color: projectProvider
                                                            .currentProject[
                                                        'estimate'] ==
                                                    estimatesProvider
                                                        .estimates[index]['id']
                                                ? greenHighLight
                                                : Colors.black,
                                            type: FontStyle.subtitle),
                                      ),
                                    ),

                                    //delete estimate
                                    IconButton(
                                      padding: const EdgeInsets.only(left: 10),
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          constraints: const BoxConstraints(
                                              maxHeight: 300),
                                          enableDrag: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: DeleteEstimateSheet(
                                                estimateName: estimatesProvider
                                                    .estimates[index]['name'],
                                                estimateId: estimatesProvider
                                                    .estimates[index]['id'],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/svg_images/delete_icon.svg',
                                        height: 20,
                                        width: 20,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.red, BlendMode.srcIn),
                                      ),
                                    ),

                                    IconButton(
                                      padding: const EdgeInsets.only(left: 10),
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                          ),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: CreateEstimate(
                                                estimatedata: estimatesProvider
                                                    .estimates[index],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined),
                                      color: greyColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            (estimatesProvider.estimates[index]
                                            ['description'] ==
                                        null ||
                                    estimatesProvider.estimates[index]
                                            ['description'] ==
                                        '')
                                ? const SizedBox()
                                : const SizedBox(
                                    height: 10,
                                  ),
                            CustomText(
                              estimatesProvider.estimates[index]
                                      ['description'] ??
                                  '',
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              type: FontStyle.title,
                              color: const Color.fromRGBO(133, 142, 150, 1),
                            ),
                            (estimatesProvider.estimates[index]
                                            ['description'] ==
                                        null ||
                                    estimatesProvider.estimates[index]
                                            ['description'] ==
                                        '')
                                ? const SizedBox()
                                : const SizedBox(
                                    height: 20,
                                  ),
                            CustomText(
                              'Estimates ($est)',
                              textAlign: TextAlign.left,
                              type: FontStyle.subtitle,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class EmptyEstimatesWidget extends ConsumerStatefulWidget {
  const EmptyEstimatesWidget({super.key});

  @override
  ConsumerState<EmptyEstimatesWidget> createState() =>
      _EmptyEstimatesWidgetState();
}

class _EmptyEstimatesWidgetState extends ConsumerState<EmptyEstimatesWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 90,
          width: 150,
          child: Stack(
            children: [
              Positioned(
                left: 80,
                bottom: 40,
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.change_history,
                          color: greyColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          '3',
                          type: FontStyle.heading2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                bottom: 20,
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.change_history,
                          color: greyColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          '2',
                          type: FontStyle.heading2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.change_history,
                          color: greyColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          '1',
                          type: FontStyle.heading2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const CustomText(
          'No Estimates Yet',
          type: FontStyle.heading,
          fontSize: 20,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: width * 0.8,
          child: const CustomText(
            'There are no estimates available for this project at the moment.',
            type: FontStyle.title,
            maxLines: 5,
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const CreateEstimate(),
                );
              },
            );
          },
          child: Container(
            height: 40,
            width: 150,
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color.fromRGBO(63, 118, 255, 1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  'Add Estimate',
                  type: FontStyle.buttonText,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
