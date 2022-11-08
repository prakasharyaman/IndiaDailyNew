import 'package:get/get.dart';
import 'package:indiadaily/ui/screens/discover/topicPage/controller/topic_controller.dart';

class TopicBindings extends Bindings {
  final String topic;
  TopicBindings({required this.topic});
  @override
  void dependencies() {
    Get.put(TopicController(topic: topic));
  }
}
