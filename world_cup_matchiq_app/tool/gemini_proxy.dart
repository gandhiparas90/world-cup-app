import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final env = await _loadEnv('.env.local');
  final apiKey =
      env['GEMINI_API_KEY'] ?? Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    stderr.writeln('GEMINI_API_KEY is missing from .env.local or environment.');
    exitCode = 1;
    return;
  }

  final port =
      int.tryParse(Platform.environment['GEMINI_PROXY_PORT'] ?? '') ?? 8787;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Gemini local proxy listening on http://127.0.0.1:$port');

  await for (final request in server) {
    await _handleRequest(request, apiKey);
  }
}

Future<void> _handleRequest(HttpRequest request, String apiKey) async {
  _setCorsHeaders(request.response);

  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }

  if (request.method != 'POST' || request.uri.path != '/generateContent') {
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('Not found');
    await request.response.close();
    return;
  }

  final model = request.uri.queryParameters['model'] ?? 'gemini-3.5-flash';
  final body = await utf8.decoder.bind(request).join();
  final client = HttpClient();

  try {
    final upstream = await client.postUrl(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
      ),
    );
    upstream.headers.contentType = ContentType.json;
    upstream.headers.set('x-goog-api-key', apiKey);
    upstream.write(body);

    final upstreamResponse = await upstream.close();
    final upstreamBody = await utf8.decoder.bind(upstreamResponse).join();

    request.response.statusCode = upstreamResponse.statusCode;
    request.response.headers.contentType = ContentType.json;
    request.response.write(upstreamBody);
  } catch (error) {
    request.response.statusCode = HttpStatus.badGateway;
    request.response.headers.contentType = ContentType.json;
    request.response.write(
      jsonEncode({'error': 'Gemini proxy request failed', 'type': '$error'}),
    );
  } finally {
    client.close(force: true);
    await request.response.close();
  }
}

void _setCorsHeaders(HttpResponse response) {
  response.headers
    ..set('Access-Control-Allow-Origin', '*')
    ..set('Access-Control-Allow-Methods', 'POST, OPTIONS')
    ..set('Access-Control-Allow-Headers', 'Content-Type')
    ..set('Cache-Control', 'no-store');
}

Future<Map<String, String>> _loadEnv(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return {};
  }

  final entries = <String, String>{};
  for (final line in await file.readAsLines()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }
    final separator = trimmed.indexOf('=');
    if (separator <= 0) {
      continue;
    }
    entries[trimmed.substring(0, separator)] = trimmed.substring(separator + 1);
  }
  return entries;
}
