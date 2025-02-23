import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Activity extends ConsumerStatefulWidget {
  const Activity({super.key});

  @override
  ConsumerState<Activity> createState() => _ActivityState();
}

class _ActivityState extends ConsumerState<Activity> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(ProviderList.activityProvider).getAcivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = ref.watch(ProviderList.activityProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      // backgroundColor: themeProvider.isDarkThemeEnabled
      //     ? darkSecondaryBackgroundColor
      //     : lightSecondaryBackgroundColor,

      body: LoadingWidget(
        loading: activityProvider.getActivityState == StateEnum.loading,
        widgetClass: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const CustomText(
                  'Activity',
                  type: FontStyle.mainHeading,
                ),
                Expanded(
                  child: activityProvider.data.isEmpty
                      ? const Center(
                          child: CustomText('No Activity'),
                        )
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: activityProvider.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 15),
                                  child: activityProvider.data[index]
                                                  ['comment'] !=
                                              null &&
                                          activityProvider.data[index]
                                                  ['field'] ==
                                              null
                                      ? SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    darkSecondaryBGC,
                                                radius: 15,
                                                child: Center(
                                                  child: CustomText(
                                                      activityProvider
                                                          .data[index]
                                                              ['actor_detail']
                                                              ['email'][0]
                                                          .toString()
                                                          .toUpperCase(),
                                                      // color: Colors.black,
                                                      type:
                                                          FontStyle.buttonText,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width -
                                                        80,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (activityProvider
                                                            .data[index]
                                                                ["comment"]
                                                            .toString()
                                                            .contains(
                                                                "created the issue")) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      IssueDetail(
                                                                        projID: activityProvider.data[index]
                                                                            [
                                                                            "project"],
                                                                        workspaceSlug:
                                                                            activityProvider.data[index]["workspace_detail"]["slug"],
                                                                        appBarTitle:
                                                                            '',
                                                                        issueId:
                                                                            activityProvider.data[index]["issue"],
                                                                      )));
                                                        } else if (activityProvider
                                                            .data[index]
                                                                ["comment"]
                                                            .toString()
                                                            .contains(
                                                                "created a link")) {
                                                          if (!await launchUrl(
                                                              Uri.parse(activityProvider
                                                            .data[index]
                                                                ["new_value"].toString()))) {
                                                             // ignore: use_build_context_synchronously
                                                             CustomToast().showToast(context, 'Failed to launch');
                                                          }
                                                        }
                                                      },
                                                      child: Wrap(
                                                        children: [
                                                          CustomText(
                                                            activityProvider
                                                                    .data[index]
                                                                ['comment'],
                                                            fontSize: 14,
                                                            type: FontStyle
                                                                .description,
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 4,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          activityProvider.data[
                                                                          index]
                                                                          [
                                                                          "comment"]
                                                                      .toString()
                                                                      .contains(
                                                                          "created the issue") ||
                                                                  activityProvider
                                                                      .data[
                                                                          index]
                                                                          [
                                                                          "comment"]
                                                                      .toString()
                                                                      .contains(
                                                                          "created a link")
                                                              ? SvgPicture
                                                                  .asset(
                                                                  "assets/svg_images/redirect.svg",
                                                                  height: 15,
                                                                  width: 15,
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    CustomText(
                                                      checkTimeDifferenc(
                                                          activityProvider
                                                                  .data[index]
                                                              ['created_at']),
                                                      color: themeProvider
                                                              .isDarkThemeEnabled
                                                          ? lightSecondaryBackgroundColor
                                                          : greyColor,
                                                      type: FontStyle.smallText,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey[100],
                                              radius: 15,
                                              child: Center(
                                                  child: activityProvider
                                                                  .data[index]
                                                              ['field'] ==
                                                          'state'
                                                      ? const Icon(
                                                          Icons
                                                              .grid_view_outlined,
                                                          size: 15,
                                                          color: greyColor,
                                                        )
                                                      : activityProvider.data[index]
                                                                  ['field'] ==
                                                              'priority'
                                                          ? SvgPicture.asset(
                                                              'assets/svg_images/priority.svg',
                                                              height: 15,
                                                              width: 15,
                                                            )
                                                          : activityProvider.data[index][
                                                                          'field'] ==
                                                                      'assignees' ||
                                                                  activityProvider.data[index][
                                                                          'field'] ==
                                                                      'assignee'
                                                              ? const Icon(
                                                                  Icons
                                                                      .people_outline,
                                                                  size: 18,
                                                                  color:
                                                                      greyColor,
                                                                )
                                                              : activityProvider
                                                                              .data[index]
                                                                          ['field'] ==
                                                                      'labels'
                                                                  ? const Icon(
                                                                      Icons
                                                                          .local_offer_outlined,
                                                                      size: 15,
                                                                      color:
                                                                          greyColor,
                                                                    )
                                                                  : activityProvider.data[index]['field'] == 'blocks'
                                                                      ? SvgPicture.asset(
                                                                          'assets/svg_images/blocked_icon.svg',
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                        )
                                                                      : activityProvider.data[index]['field'] == 'blocking'
                                                                          ? SvgPicture.asset(
                                                                              'assets/svg_images/blocking_icon.svg',
                                                                              height: 15,
                                                                              width: 15,
                                                                            )
                                                                          : activityProvider.data[index]['field'] == 'description'
                                                                              ? const Icon(
                                                                                  Icons.comment_outlined,
                                                                                  color: greyColor,
                                                                                  size: 15,
                                                                                )
                                                                              : activityProvider.data[index]['field'] == 'link'
                                                                                  ? SvgPicture.asset('assets/svg_images/link.svg', height: 15, width: 15, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                  : activityProvider.data[index]['field'] == 'modules'
                                                                                      ? SvgPicture.asset('assets/svg_images/module.svg', height: 18, width: 18, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                      : activityProvider.data[index]['field'] == 'cycles'
                                                                                          ? SvgPicture.asset('assets/svg_images/cycles_icon.svg', height: 22, width: 22, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                          : activityProvider.data[index]['field'] == 'attachment'
                                                                                              ? SvgPicture.asset('assets/svg_images/attachment.svg', height: 20, width: 20, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))
                                                                                              : activityProvider.data[index]['field'] == 'parent'
                                                                                                  ? const Icon(
                                                                                                      Icons.person_outline,
                                                                                                      size: 16,
                                                                                                      color: greyColor,
                                                                                                    )
                                                                                                  : SvgPicture.asset('assets/svg_images/calendar_icon.svg', height: 15, width: 15, colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn))),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async{
                                                      if (activityProvider
                                                          .data[index]
                                                              ["comment"]
                                                          .toString()
                                                          .contains(
                                                              "created the issue")) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    IssueDetail(
                                                                      projID: activityProvider
                                                                              .data[index]
                                                                          [
                                                                          "project"],
                                                                      workspaceSlug:
                                                                          activityProvider.data[index]["workspace_detail"]
                                                                              [
                                                                              "slug"],
                                                                      appBarTitle:
                                                                          '',
                                                                      issueId: activityProvider
                                                                              .data[index]
                                                                          [
                                                                          "issue"],
                                                                    )));
                                                      } else if (activityProvider
                                                          .data[index]
                                                              ["comment"]
                                                          .toString()
                                                          .contains(
                                                              "created a link")) { if (!await launchUrl(
                                                              Uri.parse(activityProvider
                                                            .data[index]
                                                                ["new_value"].toString()),)) {
                                                             // ignore: use_build_context_synchronously
                                                             CustomToast().showToast(context, 'Failed to launch');
                                                          }}
                                                    },
                                                    child: Wrap(
                                                      children: [
                                                        CustomText(
                                                          '${activityFormat(activityProvider.data[index])} ',
                                                          fontSize: 14,
                                                          type: FontStyle
                                                              .description,
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 4,
                                                        ),
                                                        activityProvider
                                                                    .data[index]
                                                                        [
                                                                        "comment"]
                                                                    .toString()
                                                                    .contains(
                                                                        "created the issue") ||
                                                                activityProvider
                                                                    .data[index]
                                                                        [
                                                                        "comment"]
                                                                    .toString()
                                                                    .contains(
                                                                        "created a link")
                                                            ? SvgPicture.asset(
                                                                "assets/svg_images/redirect.svg",
                                                                height: 15,
                                                                width: 15,
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  CustomText(
                                                    ' ${checkTimeDifferenc(activityProvider.data[index]['created_at'])}',
                                                    color: themeProvider
                                                            .isDarkThemeEnabled
                                                        ? lightSecondaryBackgroundColor
                                                        : greyColor,
                                                    type: FontStyle.smallText,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                Container(
                                    height: 1,
                                    width: width,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : strokeColor)
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String checkTimeDifferenc(String dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }

  String activityFormat(Map activity) {
    String formattedActivity = '';
    if (activity['actor_detail']['first_name'] != null &&
        activity['actor_detail']['last_name'] != null) {
      if (activity['field'] == 'description') {
        formattedActivity = activity['actor_detail']['first_name'] +
            " " +
            activity['actor_detail']['last_name'] +
            ' Updated the description';
      } else {
        formattedActivity = activity['comment'].toString().replaceFirst(
            activity['comment'].split(' ').first,
            activity['actor_detail']['first_name'] +
                " " +
                activity['actor_detail']['last_name']);
      }
      return formattedActivity;
    } else {
      return activity['actor_detail']['email'];
    }
  }
}
