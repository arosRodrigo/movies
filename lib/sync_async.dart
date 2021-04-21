import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  fetch();
}

Future fetch() async {
  //var url = Uri.https('http://www.omdbapi.com','',{'s':'{batman}', 'apikey':'{694b31e1}'});
  var url = 'http://www.omdbapi.com/?s=terminator&apikey=694b31e1';
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var itemCount = jsonResponse['totalResults'];
    print('Number of books about http: $itemCount.');

    return jsonResponse;
    
  } else {
      print('Request failed with status: ${response.statusCode}.');
    }
}
