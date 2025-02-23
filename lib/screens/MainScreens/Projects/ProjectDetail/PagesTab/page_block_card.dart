import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/bottom_sheets/block_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class PageBlockCard extends ConsumerStatefulWidget {
  final int index;
  final String pageID;
  const PageBlockCard({super.key, required this.index, required this.pageID});

  @override
  ConsumerState<PageBlockCard> createState() => _PageBlockCardState();
}

class _PageBlockCardState extends ConsumerState<PageBlockCard> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);

    String description = "";
    return InkWell(
      onTap: () async {
        //  ref.read(ProviderList.pageProvider).setSelectedPageBlock(widget.block);

        await showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: BlockSheet(
                  blockIndex: widget.index,
                  pageID: widget.pageID,
                  operation: CRUD.update,
                ),
              );
            });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            border: Border.all(
                color: themeProvider.isDarkThemeEnabled
                    ? darkThemeBorder
                    : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                pageProvider.blocks[widget.index]["issue"] != null
                    ? Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.only(),
                              child: SvgPicture.asset(
                                'assets/svg_images/view_card.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                    themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryTextColor
                                        : darkBackgroundColor,
                                    BlendMode.srcIn),
                              )),
                          CustomText(
                              pageProvider.blocks[widget.index]
                                      ['project_detail']["identifier"] +
                                  "-"+widget.index.toString(),
                              type: FontStyle.title),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      )
                    : Container(),
                CustomText(pageProvider.blocks[widget.index]['name'],
                    type: FontStyle.boldTitle),
              ],
            ),
            description == ''
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      CustomText(
                        description,
                        type: FontStyle.smallText,
                      ),
                    ],
                  ),
            Row(
              children: [
                const Spacer(),
              pageProvider.blocks[widget.index]["issue"]==null?  GestureDetector(
                  onTap: () async {
                    ref.read(ProviderList.pageProvider).converToIssues(
                          blockID: pageProvider.blocks[widget.index]["id"],
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'],
                          pageID: widget.pageID,
                        );
                  },
                  child: Icon(
                    Icons.flash_on,
                    size: 18,
                    color: themeProvider.isDarkThemeEnabled
                        ? lightBackgroundColor
                        : darkBackgroundColor,
                  ),
                ):Container(),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ref.read(ProviderList.pageProvider).handleBlocks(
                          blockID: pageProvider.blocks[widget.index]["id"],
                          httpMethod: HttpMethod.delete,
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'],
                          pageID: widget.pageID,
                        );
                  },
                  child: Icon(Icons.delete_outlined,
                      size: 18,
                      color: themeProvider.isDarkThemeEnabled
                          ? lightBackgroundColor
                          : darkBackgroundColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
