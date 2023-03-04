import 'package:url_launcher/url_launcher.dart';

///Launch the url
Future<void> openUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

///Launch the url in the default browser
// Future<void> openUrlInBrowser(String url) async {
//   if (url.startsWith('https://') || url.startsWith('http://')) {
//     if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   } else {
//     if (!await launchUrl(Uri.parse("https://$url"), mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }
// }

Future<void> openUrlInBrowser(String url) async {
  // Add http:// if it is missing from the url
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }

  // Attempt to launch the url
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
