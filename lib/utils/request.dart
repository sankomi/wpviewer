import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

class Request {

	static Future<Response> get(String url) async {
		http.Response res = await http.get(Uri.parse(url));

		if (res.statusCode == 200) {
			return Response(res.headers, jsonDecode(res.body));
		} else {
			return Response({}, null);
		}
	}

}

class Response {

	Map<String, String> headers;
	dynamic data;

	Response(this.headers, this.data);

}
