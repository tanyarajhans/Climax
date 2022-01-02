import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{
  NetworkHelper(this.url);

  final String url;

  Future<dynamic> getData() async{
    http.Response response = await http.get(Uri.parse(url));
    var decodedData = jsonDecode(response.body);
    return decodedData;
  }
}