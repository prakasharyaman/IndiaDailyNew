import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/common/topic_preferences_list.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/custom/multi_select_widget.dart';

class UsertopicPreferencesUpdate extends StatefulWidget {
  const UsertopicPreferencesUpdate({super.key});

  @override
  State<UsertopicPreferencesUpdate> createState() =>
      _UsertopicPreferencesUpdateState();
}

class _UsertopicPreferencesUpdateState
    extends State<UsertopicPreferencesUpdate> {
  AppController appController = Get.find<AppController>();
  String updateButtonText = 'Update';
  List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Topic Preferences',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          CustomMultiSelectField(
              title: 'Update the topics you would love to read?',
              subtitle: 'Select at least 3',
              initialValue: appController.userTopicPreferences,
              onTap: (_) {
                selectedTopics = List<String>.from(_);
              },
              items: kTopicPreferencesList),
          // elevated card with text button that says update
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: Get.width,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                      onPressed: () {
                        if (selectedTopics.length < 3) {
                          EasyLoading.showToast('Select at least 3');
                        } else {
                          saveTopicPreferences(topicsList: selectedTopics);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryRed,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          updateButtonText,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontFamily:
                                      GoogleFonts.archivoBlack().fontFamily,
                                  color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Saves topic preferences using app controller .
  saveTopicPreferences({required List<String> topicsList}) async {
    EasyLoading.show(status: 'Loading...');
    await appController.saveUserTopicPrefernces(topics: topicsList);
    await appController.setValue(of: "shownTopicPreferences", to: true);
    appController.userTopicPreferences = topicsList;
    EasyLoading.dismiss();
    EasyLoading.showSuccess('Updated Your Topics');
    setState(() {
      updateButtonText = 'Updated Recently';
    });
  }
}
