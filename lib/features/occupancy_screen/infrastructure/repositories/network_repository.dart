import 'package:http/http.dart' as http;




abstract class INetworkRepository {
  Future<String> scrape();
}


class NetworkRepository extends INetworkRepository {

  final http.Client client = http.Client();
  final String url = "https://sport.wp.st-andrews.ac.uk/";

  @override
    Future<String> scrape() async {
      final response = await client.get(Uri.parse(url));
      final regex = RegExp("Occupancy:\\s+(\\d+)%");
      RegExpMatch match = regex.firstMatch(response.body)!;
      return match.group(1)!;
    }
}


