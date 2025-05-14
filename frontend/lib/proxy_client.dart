import 'package:http/http.dart' as http;

// This is a simple proxy client that changes the port of the request, and https to http
class ProxyClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  ProxyClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var uri = request.url;
    var newUri = uri.replace(port: 8000, scheme: 'http');
    var modifiedRequest = http.Request(request.method, newUri);
    modifiedRequest.headers.addAll(request.headers);
    modifiedRequest.body = request is http.Request ? request.body : "";
    return _inner.send(modifiedRequest);
  }
}
