import 'dart:convert';
import 'package:http/http.dart' as http;

class Chuck {
  final String iconUrl;
  final String id;
  final String url;
  final String value;

  Chuck({
    required this.iconUrl,
    required this.id,
    required this.url,
    required this.value,
  });

  factory Chuck.fromJson(Map<String, dynamic> json) {
    return Chuck(
      iconUrl: json['icon_url'],
      id: json['id'],
      url: json['url'],
      value: json['value'],
    );
  }
}

Future<Chuck> chuckApiCall() async {
  const url ="https://api.chucknorris.io/jokes/random";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Chuck.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}