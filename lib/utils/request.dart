import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

export "package:http/http.dart" show Response;

class Request {

	static Future<dynamic> get(String url) async {
		http.Response res = await http.get(Uri.parse(url));

		if (res.statusCode == 200) {
			return jsonDecode(res.body);
		} else {
			return null;
		}
	}

}
