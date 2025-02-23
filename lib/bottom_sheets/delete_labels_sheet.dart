import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';


class DeleteLabelSheet extends ConsumerStatefulWidget {
  final String labelName;
  final String labelId;
  const DeleteLabelSheet(
      {required this.labelName, required this.labelId, super.key});

  @override
  ConsumerState<DeleteLabelSheet> createState() => _DeleteLabelSheetState();
}

class _DeleteLabelSheetState extends ConsumerState<DeleteLabelSheet> {
  @override
  Widget build(BuildContext context) {
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Delete Label',
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
              const SizedBox(
                height: 20,
              ),
              CustomText(
                'Are you sure you want to delete label- ${widget.labelName}? The label will be removed from all the issues.',
                type: FontStyle.heading2,
                fontSize: 20,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Button(
              ontap: () {
                issuesProvider.issueLabels(
                    slug: ref
                        .watch(ProviderList.workspaceProvider)
                        .selectedWorkspace!
                        .workspaceSlug,
                    projID: ref
                        .watch(ProviderList.projectProvider)
                        .currentProject['id'],
                    method: CRUD.delete,
                    data: {},
                    labelId: widget.labelId);
                Navigator.of(context).pop();
              },
              text: 'Delete Label',
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
