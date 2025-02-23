import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class StatusSheet extends ConsumerStatefulWidget {
  const StatusSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatusSheetState();
}

class _StatusSheetState extends ConsumerState<StatusSheet> {
  @override
  Widget build(BuildContext context) {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Status',
                type: FontStyle.heading,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 27,
                  color: Color.fromRGBO(143, 143, 147, 1),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(0);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 0
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[0]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[0]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(1);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 1
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[1]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[1]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(2);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 2
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[2]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[2]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(3);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 3
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[3]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[3]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(4);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 4
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[4]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[4]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: themeProvider.isDarkThemeEnabled
                  ? darkThemeBorder
                  : Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () {
              modulesProvider.changeIndex(5);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Radio(
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: modulesProvider.statusIndex == 5
                          ? null
                          : MaterialStateProperty.all<Color>(
                              Colors.grey.shade300,
                            ),
                      groupValue: modulesProvider.moduleSatatus[5]['value'],
                      activeColor: primaryColor,
                      value: modulesProvider.createModule['status'],
                      onChanged: (val) {}),
                  const SizedBox(width: 10),
                  CustomText(
                    modulesProvider.moduleSatatus[5]['name'].toString(),
                    type: FontStyle.subheading,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
