import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

void main() async {
  final res = await http.get(Uri.parse('https://bible.usccb.org/readings.rss'));
  final doc = XmlDocument.parse(res.body);
  final item = doc.findAllElements('item').first;
  String description = item.findElements('description').firstOrNull?.innerText ?? '';
  
  // Split by <h4>
  final chunks = description.split('<h4>');
  for (int i = 1; i < chunks.length; i++) {
    final chunk = chunks[i];
    final titleEnd = chunk.indexOf('</h4>');
    if (titleEnd == -1) continue;
    
    final fullTitle = chunk.substring(0, titleEnd).trim();
    // fullTitle might look like "Reading 1  <a href=...>Galatians 3:1-5</a>"
    final aStart = fullTitle.indexOf('<a');
    final aEnd = fullTitle.indexOf('>', aStart);
    final aClose = fullTitle.indexOf('</a>');
    
    String title = fullTitle;
    String citation = '';
    if (aStart != -1 && aClose != -1) {
      title = fullTitle.substring(0, aStart).trim();
      citation = fullTitle.substring(aEnd + 1, aClose).trim();
    }
    
    String text = chunk.substring(titleEnd + 5);
    // remove - - - and copyright
    final footerIndex = text.indexOf('- - -');
    if (footerIndex != -1) {
      text = text.substring(0, footerIndex);
    }
    
    print('TITLE: $title');
    print('CITATION: $citation');
    print('TEXT LENGTH: ${text.length}');
  }
}