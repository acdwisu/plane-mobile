import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/block_sheet.dart';
import 'package:plane_startup/bottom_sheets/label_sheet.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_block_card.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class PageDetail extends ConsumerStatefulWidget {
  const PageDetail({required this.index, super.key});
  final int index;
  @override
  ConsumerState<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends ConsumerState<PageDetail> {
  TextEditingController colorController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List lables = [
    '#B71F1F',
    '#08AB22',
    '#BC009E',
    '#F15700',
    '#290CDE',
    '#B1700D',
    '#08BECA',
    '#6500CA',
    '#E98787',
    '#ADC57C',
    '#75A0C8',
    '#E96B6B'
  ];
  @override
  void initState() {
    var prov = ref.read(ProviderList.pageProvider);
    prov.handleBlocks(
        blockID: "",
        httpMethod: HttpMethod.get,
        pageID: prov.pages[prov.selectedFilter]![widget.index]["id"],
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace!
            .workspaceSlug,
        projectId: ref.read(ProviderList.projectProvider).currentProject["id"]);
    ref.read(ProviderList.issuesProvider).getLabels(
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace!
            .workspaceSlug,
        projID: ref.read(ProviderList.projectProvider).currentProject["id"]);

    titleController.text =
        prov.pages[prov.selectedFilter]![widget.index]['name'] ?? '';
    colorController.text =
        prov.pages[prov.selectedFilter]![widget.index]['color'] ?? lables[0];
    super.initState();
  }

  bool showColor = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
  //  log(projectProvider.currentProject["id"]);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                          radix: 16) ==
                      null ||
                  colorController.text.trim().isEmpty
              ? colorController.text = lables[0]
              : null;
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['color'] = '#${colorController.text}';
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['name'] = titleController.text;
          pageProvider.editPage(
              slug: workspaceProvider.selectedWorkspace!.workspaceSlug,
              projectId: projectProvider.currentProject['id'],
              pageId: pageProvider
                  .pages[pageProvider.selectedFilter]![widget.index]['id'],
              data: {
                "color": '#${colorController.text}',
                "name": titleController.text
              });
          Navigator.pop(context);
        },
        text: pageProvider.pages[pageProvider.selectedFilter]![widget.index]
                ['name'] ??
            'Error',
      ),
      body: WillPopScope(
        onWillPop: () async {
          int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                          radix: 16) ==
                      null ||
                  colorController.text.trim().isEmpty
              ? colorController.text = lables[0]
              : null;

          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['color'] = '#${colorController.text}';
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['name'] = titleController.text;
          pageProvider.editPage(
              slug: workspaceProvider.selectedWorkspace!.workspaceSlug,
              projectId: projectProvider.currentProject['id'],
              pageId: pageProvider
                  .pages[pageProvider.selectedFilter]![widget.index]['id'],
              data: {
                "color": '#${colorController.text}',
                "name": titleController.text
              });

          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : strokeColor,
              width: double.infinity,
            ),
            //contaier containing a text ands four small icons
            Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkSecondaryBGC
                  : lightSecondaryBackgroundColor,
              //margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  //container containing a add icon and a text
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.8),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                          context: context,
                          builder: (ctx) {
                            return Padding(
                              padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: LabelSheet(
                                selectedLabels: pageProvider.pages[pageProvider.selectedFilter]![widget.index]["labels"]??[],
                                pageIndex: widget.index,
                              ),
                            );
                          });
                    },
                    child: Container(
                      color: themeProvider.isDarkThemeEnabled
                          ? darkBackgroundColor
                          : lightBackgroundColor,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          //add icon
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.add,
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkPrimaryTextColor
                                  : lightPrimaryTextColor,
                              size: 22,
                            ),
                          ),
                          const CustomText(
                            'Add Labels',
                            type: FontStyle.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  //four small icons
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(
                      Icons.link,
                      color: greyColor,
                      size: 22,
                    ),
                  ),
                  //icon 2
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          showColor = !showColor;
                        });
                        int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                        radix: 16) ==
                                    null ||
                                colorController.text.trim().isEmpty
                            ? colorController.text = lables[0]
                            : null;
                        if (showColor == false) {
                          pageProvider.pages[pageProvider.selectedFilter]![
                                  widget.index]['color'] =
                              '#${colorController.text}';
                          pageProvider.editPage(
                              slug: workspaceProvider
                                  .selectedWorkspace!.workspaceSlug,
                              projectId: projectProvider.currentProject['id'],
                              pageId: pageProvider.pages[pageProvider
                                  .selectedFilter]![widget.index]['id'],
                              data: {"color": '#${colorController.text}'});
                        }
                      },
                      icon: Icon(
                        Icons.color_lens,
                        color: int.tryParse(
                                        "FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                        radix: 16) ==
                                    null ||
                                colorController.text.trim().isEmpty
                            ? Color(int.parse(
                                lables[0].toUpperCase().replaceAll("#", "FF"),
                                radix: 16))
                            : Color(int.parse(
                                "FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                                radix: 16)),
                        size: 22,
                      ),
                    ),
                  ),
                  //icon 3
 InkWell(
                  onTap: () {
                    pageProvider
                            .pages[pageProvider.selectedFilter]![widget.index]
                        ['access'] = pageProvider.pages[pageProvider
                                .selectedFilter]![widget.index]['access'] ==
                            1
                        ? 0
                        : 1;
                    pageProvider.editPage(
                      pageId: pageProvider
                              .pages[pageProvider.selectedFilter]![widget.index]
                          ['id'],
                      slug: workspaceProvider.selectedWorkspace!.workspaceSlug,
                      projectId: projectProvider.currentProject['id'],
                      data: {
                        "access": pageProvider.pages[pageProvider
                                .selectedFilter]![widget.index]['access']
                      },
                    );
                    setState(() {
                      
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: pageProvider.pages[pageProvider.selectedFilter]![
                                widget.index]['access'] ==
                            0 // 1 = locked || 0 = unlocked
                        ? const Icon(
                            Icons.lock_open_outlined,
                            size: 20,
                            color: Color.fromRGBO(172, 181, 189, 1),
                          )
                        : const Icon(
                            Icons.lock_clock_outlined,
                            size: 20,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                  ),
                ),
                  //icon 4
                       Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: pageProvider.pages[pageProvider.selectedFilter]![
                                widget.index]['is_favorite'] ==
                            true
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                pageProvider.pages[pageProvider
                                        .selectedFilter]![widget.index]
                                    ['is_favorite'] = !pageProvider
                                        .pages[pageProvider.selectedFilter]![
                                    widget.index]['is_favorite'];
                              });
                              pageProvider.makePageFavorite(
                                  pageId: pageProvider.pages[pageProvider
                                      .selectedFilter]![widget.index]['id'],
                                  slug: workspaceProvider
                                      .selectedWorkspace!.workspaceSlug,
                                  projectId:
                                      projectProvider.currentProject['id'],
                                  shouldItBeFavorite: false);
                            },
                            child: const Icon(Icons.star,
                                size: 20, color: Colors.amber))
                        : InkWell(
                            onTap: () {
                              setState(() {
                                pageProvider.pages[pageProvider
                                        .selectedFilter]![widget.index]
                                    ['is_favorite'] = !pageProvider
                                        .pages[pageProvider.selectedFilter]![
                                    widget.index]['is_favorite'];
                              });
                              pageProvider.makePageFavorite(
                                  pageId: pageProvider.pages[pageProvider
                                      .selectedFilter]![widget.index]['id'],
                                  slug: workspaceProvider
                                      .selectedWorkspace!.workspaceSlug,
                                  projectId:
                                      projectProvider.currentProject['id'],
                                  shouldItBeFavorite: true);
                            },
                            child: const Icon(Icons.star_border,
                                size: 20,
                                color: Color.fromRGBO(172, 181, 189, 1))))
                ],
              ),
            ),
            Container(
              height: 1,
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : strokeColor,
              width: double.infinity,
            ),
            const SizedBox(
              height: 15,
            ),

            showColor
                ? Card(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC
                        : lightSecondaryBackgroundColor,
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 15),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 5,
                            children: lables
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        colorController.text = e
                                            .toString()
                                            .toUpperCase()
                                            .replaceAll("#", "");
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            "FF${e.toString().toUpperCase().replaceAll("#", "")}",
                                            radix: 16)),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 1.0,
                                              color: greyColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          // height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 55,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                    radix: 16) ==
                                                null ||
                                            colorController.text.trim().isEmpty
                                        ? Color(int.parse(
                                            lables[0]
                                                .toUpperCase()
                                                .replaceAll("#", "FF"),
                                            radix: 16))
                                        : Color(int.parse(
                                            "FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                                            radix: 16)),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8))),
                                child: const CustomText(
                                  '#',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '*required';
                                    }
                                    return null;
                                  },
                                  controller: colorController,
                                  maxLength: 6,
                                  onChanged: (val) {
                                    colorController.text = val.toUpperCase();
                                    colorController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                colorController.text.length));
                                    setState(() {});
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                    counterText: '',
                                    errorStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade600,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade600,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : Colors.grey.shade300,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              themeProvider.isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : Colors.grey.shade300,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    fillColor: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryBGC
                                        : const Color.fromRGBO(
                                            250, 250, 250, 1),
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),

            Container(
              child: Wrap(
                  direction: Axis.horizontal,
                  children: (pageProvider
                              .pages[pageProvider.selectedFilter]![widget.index]
                          ['label_details'] as List)
                      .map((element) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: themeProvider.isDarkThemeEnabled
                                ? darkThemeBorder
                                : strokeColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.only(left: 15),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          //container 1
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(
                              int.parse(
                                "FF${element['color'].toString().toUpperCase().replaceAll("#", "")}",
                                radix: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //container 2
                          Container(
                            child: CustomText(
                              element["name"],
                              type: FontStyle.title,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
            ),
            (pageProvider.pages[pageProvider.selectedFilter]![widget.index]
                        ['label_details'] as List)
                    .isNotEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                decoration: const InputDecoration(border: InputBorder.none),
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                controller: titleController,
                maxLines: null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  context: context,
                  builder: (ctx) {
                    return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BlockSheet(
                          operation: CRUD.create,
                          pageID: pageProvider.pages[
                              pageProvider.selectedFilter]![widget.index]['id'],
                        ));
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: const Row(
                  children: [
                    //add icon
                    Icon(
                      Icons.add,
                      color: primaryColor,
                      size: 22,
                    ),

                    //text
                    CustomText(
                      'Add new block',
                      type: FontStyle.text,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LoadingWidget(
                loading: pageProvider.pagesListState == StateEnum.loading ||
                    pageProvider.blockState == StateEnum.loading,
                widgetClass: ListView.builder(
                  itemCount: pageProvider.blocks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: PageBlockCard(
                        pageID: pageProvider.pages[
                            pageProvider.selectedFilter]![widget.index]['id'],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
