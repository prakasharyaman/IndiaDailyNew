import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indiadaily/app/controller/app_controller.dart';
import 'package:indiadaily/ui/constants.dart';
import 'package:indiadaily/custom/multi_select_widget.dart';
import '../../../../services/notification_services.dart';
import '../../../common/topic_preferences_list.dart';

class TopicPreferences extends StatefulWidget {
  const TopicPreferences({super.key});
  @override
  State<TopicPreferences> createState() => _TopicPreferencesState();
}

class _TopicPreferencesState extends State<TopicPreferences> {
  // controller for app
  AppController appController = Get.find<AppController>();
  // list of selected topics
  List<String> selectedTopics = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // multi select field
          SafeArea(
            child: CustomMultiSelectField(
                items: kTopicPreferencesList,
                subtitle: 'Select at least 3',
                onTap: (slectedValues) {
                  selectedTopics = List<String>.from(slectedValues);
                },
                showDivider: true,
                initialValue: appController.userTopicPreferences,
                title: 'Which topics would you love to read?'),
          ),
          // buttons for skipping and continue
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    if (selectedTopics.length < 3) {
                      EasyLoading.showToast('Select at least 3');
                    } else {
                      saveTopicPreferences(topicsList: selectedTopics);
                    }
                  },
                  // text button style
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryRed,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Continue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: GoogleFonts.archivoBlack().fontFamily,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // /// Prompts user to try selecting topics if he wants to skip.
  // Future<dynamic> showSkipDialog() {
  //   return Get.defaultDialog(
  //       radius: 12,
  //       title: 'Are you sure you want to skip?',
  //       middleText:
  //           'Skipping will show news and posts that you may not like. You can always change the topics you love through settings afterwards.',
  //       textConfirm: 'Yes Skip',
  //       onConfirm: () async {
  //         Get.back();
  //         appController.userRepository.updateUserProfile(
  //             userId: appController.userModel.value.id!,
  //             profile: {'skipped': true});
  //         saveTopicPreferences(topicsList: ['all']);
  //       },
  //       textCancel: 'Cancel');
  // }

  /// Saves topic preferences.
  saveTopicPreferences({required List<String> topicsList}) async {
    EasyLoading.show(status: 'Loading...');
    // updates device model and date of joining
    await appController.userRepository
        .logUserFirstTimeLogin(userId: appController.userModel.value.id!);
    await appController.saveUserTopicPrefernces(topics: topicsList);
    await appController.setValue(of: "shownTopicPreferences", to: true);
    appController.userRepository.updateUserProfile(
        userId: appController.userModel.value.id!,
        profile: {'topics': topicsList});
    EasyLoading.dismiss();
    appController.runAppLogic();
  }
}
// Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextButton(
//                           onPressed: () {
//                             showSkipDialog();
//                           },
//                           style: TextButton.styleFrom(
//                               side: BorderSide(color: kPrimaryRed)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'Skip',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium
//                                   ?.copyWith(
//                                       fontFamily: GoogleFonts.archivoBlack()
//                                           .fontFamily,
//                                       color: kPrimaryRed),
//                             ),
//                           )),
//                     ),
//                   ),
