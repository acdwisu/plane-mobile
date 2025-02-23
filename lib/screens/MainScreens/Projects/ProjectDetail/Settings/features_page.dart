import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class FeaturesPage extends ConsumerStatefulWidget {
  const FeaturesPage({super.key});

  @override
  ConsumerState<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends ConsumerState<FeaturesPage> {
  List cardData = [
    {
      'title': 'Cycles',
      'description':
          'Cycles are enabled for all the projects in this workspace. Access them from the sidebar.',
      'switched': false
    },
    {
      'title': 'Modules',
      'description':
          'Modules are enabled for all the projects in this workspace. Access it from the sidebar.',
      'switched': false
    },
    // {
    //   'title': 'Views',
    //   'description':
    //       'Views are enabled for all the projects in this workspace. Access it from the sidebar.',
    //   'switched': false
    // },
    // {
    //   'title': 'Pages',
    //   'description':
    //       'Pages are enabled for all the projects in this workspace. Access it from the sidebar.',
    //   'switched': false
    // }
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectsProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      color: themeProvider.isDarkThemeEnabled
          ? darkSecondaryBackgroundDefaultColor
          : lightSecondaryBackgroundDefaultColor,
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : strokeColor),
                borderRadius: BorderRadius.circular(10),
                color: themeProvider.isDarkThemeEnabled
                    ? darkBackgroundColor
                    : lightBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          cardData[index]['title'],
                          textAlign: TextAlign.left,
                          // color: Colors.black,
                          type: FontStyle.heading2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width * 0.7,
                          child: CustomText(
                            cardData[index]['description'],
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        projectsProvider.features[index + 1]['show'] =
                            !projectsProvider.features[index + 1]['show'];
                        projectsProvider.setState();
                        // print(projectsProvider.features[index + 1]);
                        // projectsProvider.updateProject(
                        //     slug: ref
                        //         .read(ProviderList.workspaceProvider)
                        //         .selectedWorkspace!
                        //         .workspaceSlug,
                        //     projId: ref
                        //         .read(ProviderList.projectProvider)
                        //         .currentProject['id'],
                        //     data: {
                        //       if (projectsProvider.features[index + 1]
                        //               ['title'] ==
                        //           'Cycles')
                        //         "cycle_view": projectsProvider
                        //             .features[index + 1]['show'],
                        //       if (projectsProvider.features[index + 1]
                        //               ['title'] ==
                        //           'Modules')
                        //         "module_view": projectsProvider
                        //             .features[index + 1]['show'],
                        //       if (projectsProvider.features[index + 1]
                        //               ['title'] ==
                        //           'Views')
                        //         "issue_views_view": projectsProvider
                        //             .features[index + 1]['show'],
                        //       if (projectsProvider.features[index + 1]
                        //               ['title'] ==
                        //           'Pages')
                        //         "page_view": projectsProvider
                        //             .features[index + 1]['show'],
                        //     });
                      },
                      child: Container(
                        width: 30,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: projectsProvider.features[index + 1]['show']
                                ? Colors.green
                                : Colors.grey[300]),
                        child: Align(
                          alignment: projectsProvider.features[index + 1]
                                  ['show']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: const CircleAvatar(radius: 6),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
