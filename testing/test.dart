import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getVideo(String url) async {
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      RegExp regExp = RegExp(r'(?<=window.data =)(.*)(?=;<)');
      final data = regExp.stringMatch(response.body.toString());
      final jsonData = jsonDecode(data);

      return {
        'status_code': response.statusCode,
        'url': jsonData['video_url'].replaceAll('_4', ''),
        'thumbnail': jsonData['image2'],
        'username': jsonData['user_name']
      };
    } else
      return {
        'status_code': response.statusCode,
        'url': null,
        'thumbnail': null,
        'username': null
      };
  } catch (e) {
    return {
      'status_code': 500,
      'url': null,
      'thumbnail': null,
      'username': null
    };
  }
}

main(List<String> args) async {
  final rsp = await getVideo('https://l.likee.com/v/80jT9Q');
  print(rsp);
}
