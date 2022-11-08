import 'package:flutter/material.dart';
import 'package:indiadaily/ui/common/app_title.dart';
import 'package:indiadaily/ui/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(
      {super.key,
      this.title =
          'Something wrong just happended and we are trying to fix it.',
      this.buttonText = 'Retry',
      required this.onTap});
  final String title;
  final String buttonText;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppTitle(context),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
                onPressed: () {
                  onTap();
                },
                style: TextButton.styleFrom(
                    backgroundColor: kPrimaryRed, elevation: 5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttonText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
