
import 'package:budget_buddy/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  final int total;

  const AppDrawer({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Daily Spendings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail),
                    title: const Text("Contact Us"),
                    onTap: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'mufaddalshakir55@gmail.com',
                        queryParameters: {
                          'subject': 'NeedHelp',
                          'body': 'Contact Reason: '
                        },
                      );
                      if (await canLaunchUrl(emailUri)) {
                        Navigator.of(context).pop();
                        await launchUrl(emailUri);
                      }
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/github.png',
                      color: Colors.grey,
                    ),
                    title: const Text("Contribute"),
                    onTap: () async {
                      final Uri githubUri = Uri.parse(
                          "https://github.com/Mufaddal5253110/DailySpending.git");
                      if (await canLaunchUrl(githubUri)) {
                        Navigator.of(context).pop();
                        await launchUrl(githubUri);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Total: ₹$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
