import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class CatholicNewsItem {
  final String title;
  final String link;
  final String description;
  final String pubDate;
  final String? imageUrl;

  CatholicNewsItem({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    this.imageUrl,
  });
}

class CatholicNewsService extends ChangeNotifier {
  static final CatholicNewsService _instance = CatholicNewsService._internal();
  factory CatholicNewsService() => _instance;
  CatholicNewsService._internal();

  List<CatholicNewsItem> _newsItems = [];
  bool _isLoading = false;

  List<CatholicNewsItem> get newsItems => _newsItems;
  bool get isLoading => _isLoading;

  Future<List<CatholicNewsItem>> fetchCatholicNews() async {
    if (_newsItems.isNotEmpty) return _newsItems;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://www.vaticannews.va/en.rss.xml'),
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        List<CatholicNewsItem> fetched = [];
        for (var item in items.take(6)) {
          final title = item.findElements('title').firstOrNull?.innerText ?? '';
          final link = item.findElements('link').firstOrNull?.innerText ?? '';
          final descriptionRaw = item.findElements('description').firstOrNull?.innerText ?? '';
          final pubDate = item.findElements('pubDate').firstOrNull?.innerText ?? '';
          
          String? mediaUrl = item.findElements('enclosure').firstOrNull?.getAttribute('url') ??
                             item.findElements('media:content').firstOrNull?.getAttribute('url');

          final cleanDesc = _stripHtml(descriptionRaw);

          if (title.isNotEmpty) {
            fetched.add(CatholicNewsItem(
              title: title.trim(),
              link: link.trim(),
              description: cleanDesc,
              pubDate: pubDate.trim(),
              imageUrl: mediaUrl,
            ));
          }
        }

        if (fetched.isNotEmpty) {
          _newsItems = fetched;
        } else {
          _newsItems = _getFallbackNews();
        }
      } else {
        _newsItems = _getFallbackNews();
      }
    } catch (e) {
      debugPrint('Error fetching Vatican news: $e');
      _newsItems = _getFallbackNews();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _newsItems;
  }

  List<CatholicNewsItem> _getFallbackNews() {
    return [
      CatholicNewsItem(
        title: 'Pope Francis Calls for Global Peace and Universal Unity',
        link: 'https://www.vaticannews.va',
        description: 'During the Angelus prayer at Saint Peter Square, the Holy Father urged believers worldwide to unite in daily prayer for international peace and fraternity.',
        pubDate: 'Vatican City',
        imageUrl: 'https://images.unsplash.com/photo-1548625149-fc4a29cf7092?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
      ),
      CatholicNewsItem(
        title: 'Preparation for Jubilee Year in Rome',
        link: 'https://www.vaticannews.va',
        description: 'Pilgrims from around the world prepare to journey to Rome for the upcoming Holy Jubilee, celebrating faith, hope, and reconciliation across all dioceses.',
        pubDate: 'Rome, Italy',
        imageUrl: 'https://images.unsplash.com/photo-1519817650390-64a93db51149?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
      ),
      CatholicNewsItem(
        title: 'Catholic Youth Gatherings & Global Mission Initiatives',
        link: 'https://www.vaticannews.va',
        description: 'Young Catholics worldwide participate in missionary outreach and prayer movements, sharing the Gospel through acts of charity and service.',
        pubDate: 'World News',
        imageUrl: 'https://images.unsplash.com/photo-1464207687429-7505649dae38?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
      ),
    ];
  }

  String _stripHtml(String htmlText) {
    String text = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&ldquo;', '"');
    text = text.replaceAll('&rdquo;', '"');
    return text.trim();
  }
}
