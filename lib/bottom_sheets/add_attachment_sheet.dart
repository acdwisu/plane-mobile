// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class AddAttachmentsSheet extends ConsumerStatefulWidget {
  AddAttachmentsSheet(
      {super.key,
      required this.projectId,
      required this.slug,
      required this.issueId,
 });

  String projectId;
  String slug;
  String issueId;

  @override
  ConsumerState<AddAttachmentsSheet> createState() =>
      _AddAttachmentsSheetState();
}

class _AddAttachmentsSheetState extends ConsumerState<AddAttachmentsSheet> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var issueProvider = ref.read(ProviderList.issueProvider);

    //List<String> allowedAttachmentFileExtensiones = ['PNG', 'JPEG', 'PDF'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Insert File',
                type: FontStyle.heading,
                // color: themeProvider.secondaryTextColor,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: themeProvider.isDarkThemeEnabled
                        ? lightBackgroundColor
                        : darkBackgroundColor,
                  ))
            ],
          ),
          const SizedBox(height: 15),
          Button(
              text: 'Select FIle',
              ontap: () async {
                final result = await FilePicker.platform.pickFiles(
                    //allowMultiple: true,
                    //type: FileType.custom,
                    //allowedExtensions: allowedAttachmentFileExtensiones
                    );

                if (result == null) {
                  CustomToast().showToast(context, 'File is empty');
                  Navigator.pop(context);
                  return;
                } else if (result.files.single.size > 5000000) {
                  CustomToast()
                      .showToast(context, 'File size should be less than 5MB');
                  Navigator.pop(context);
                  return;
                } else {
                  String? path = result.files.single.path;

                  issueProvider.addIssueAttachment(
                      fileSize: result.files.single.size,
                      filePath: path!,
                      projectId: widget.projectId,
                      slug: widget.slug,
                      issueId: widget.issueId,
                    );
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}
