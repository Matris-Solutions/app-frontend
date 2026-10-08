import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ReadingItem {
  final String title;
  final String citation;
  final String text;

  ReadingItem({
    required this.title,
    required this.citation,
    required this.text,
  });
}

class LiturgicalService extends ChangeNotifier {
  // Singleton instance
  static final LiturgicalService _instance = LiturgicalService._internal();

  factory LiturgicalService() {
    return _instance;
  }

  LiturgicalService._internal();

  bool _isLoading = true;
  bool _hasError = false;

  String _liturgyTitle = 'Ordinary Time';
  String _liturgicalColor = 'green';
  List<ReadingItem> _dailyReadings = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get liturgyTitle => _liturgyTitle;
  String get liturgicalColor => _liturgicalColor;
  List<ReadingItem> get dailyReadings => _dailyReadings;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // 1. Fetch Liturgical Calendar API
      final calendarResponse = await http.get(
        Uri.parse('https://litcal.johnromanodorazio.com/api/v4/calendars/default/today'),
      );

      if (calendarResponse.statusCode == 200) {
        final data = jsonDecode(calendarResponse.body);
        String colorStr = 'green';
        if (data['color'] != null) {
          colorStr = data['color'].toString().toLowerCase();
        } else if (data['celebrations'] != null &&
            (data['celebrations'] as List).isNotEmpty) {
          final celebration = data['celebrations'][0];
          if (celebration['color'] != null) {
            colorStr = celebration['color'].toString().toLowerCase();
          } else if (celebration['colors'] != null &&
              (celebration['colors'] as List).isNotEmpty) {
            colorStr = celebration['colors'][0].toString().toLowerCase();
          }
        }

        String titleStr = 'Ordinary Time';
        if (data['name'] != null) {
          titleStr = data['name'].toString();
        } else if (data['celebrations'] != null &&
            (data['celebrations'] as List).isNotEmpty) {
          titleStr = data['celebrations'][0]['title']?.toString() ?? 'Ordinary Time';
        }

        _liturgicalColor = colorStr;
        _liturgyTitle = titleStr;
      }

      // 2. Fetch USCCB Daily Readings RSS Feed
      final rssResponse = await http.get(
        Uri.parse('https://bible.usccb.org/readings.rss'), // The correct real-time RSS endpoint
      );

      if (rssResponse.statusCode == 200) {
        final document = XmlDocument.parse(rssResponse.body);
        final item = document.findAllElements('item').firstOrNull; // Only fetch TODAY's readings

        if (item != null) {
          String description = item.findElements('content:encoded').firstOrNull?.innerText ?? 
                               item.findElements('description').firstOrNull?.innerText ?? '';

          List<ReadingItem> fetchedReadings = [];
          final chunks = description.split('<h4>');
          
          for (int i = 1; i < chunks.length; i++) {
            final chunk = chunks[i];
            final titleEnd = chunk.indexOf('</h4>');
            if (titleEnd == -1) continue;
            
            final fullTitle = chunk.substring(0, titleEnd).trim();
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
            // remove footer / copyright from the text since it's hardcoded in the UI
            final footerIndex = text.indexOf('- - -');
            if (footerIndex != -1) {
              text = text.substring(0, footerIndex);
            }

            if (text.isNotEmpty && _stripHtml(text).trim().isNotEmpty) {
              fetchedReadings.add(ReadingItem(
                title: title,
                citation: citation.isNotEmpty ? citation : 'USCCB Daily Readings',
                text: _stripHtml(text),
              ));
            }
          }

          if (fetchedReadings.isNotEmpty) {
            _dailyReadings = fetchedReadings;
          } else {
            _loadFallbackReadings();
          }
        } else {
          _loadFallbackReadings();
        }
      } else {
        _loadFallbackReadings();
      }
    } catch (e) {
      print('Network error fetching liturgical data: $e');
      _hasError = true;
      _loadFallbackReadings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadFallbackReadings() {
    _dailyReadings = [
      ReadingItem(
        title: 'Reading I',
        citation: '1 Kings 19:9a, 11-16',
        text: 'At the mountain of God, Horeb, the word of the LORD came to him...',
      ),
      ReadingItem(
        title: 'Responsorial Psalm',
        citation: 'Psalm 27:7-8, 9abc, 13-14',
        text: 'The Lord is my light and my salvation.',
      ),
      ReadingItem(
        title: 'Gospel',
        citation: 'Matthew 5:13-16',
        text: 'Jesus said to his disciples: "You are the salt of the earth..."',
      ),
    ];
  }

  String _stripHtml(String htmlText) {
    // Keep line breaks by replacing <br> and <p> tags with actual newlines
    String text = htmlText.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');
    
    // Remove all remaining HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Unescape common HTML entities
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    text = text.replaceAll('&ldquo;', '"');
    text = text.replaceAll('&rdquo;', '"');
    text = text.replaceAll('&rsquo;', "'");
    text = text.replaceAll('&lsquo;', "'");
    text = text.replaceAll('&mdash;', '—');
    text = text.replaceAll('&ndash;', '–');
    
    // Fix excess newlines resulting from poor formatting in RSS
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return text.trim();
  }

  // Dynamic Theming Helper Functions mapping API color string to Color objects
  Color get primaryColor {
    switch (_liturgicalColor) {
      case 'violet':
      case 'purple':
        return const Color(0xFF5E3A71);
      case 'white':
      case 'gold':
        return const Color(0xFFC4A46B);
      case 'red':
        return const Color(0xFF9E2A2B);
      case 'rose':
        return const Color(0xFFD68A9A);
      case 'green':
      default:
        return const Color(0xFF4A7C59);
    }
  }

  Color get darkColor {
    switch (_liturgicalColor) {
      case 'violet':
      case 'purple':
        return const Color(0xFF3B224A);
      case 'white':
      case 'gold':
        return const Color(0xFF8C7144);
      case 'red':
        return const Color(0xFF5A1414);
      case 'rose':
        return const Color(0xFF8F4C5A);
      case 'green':
      default:
        return const Color(0xFF28553A);
    }
  }

  Color get paleColor {
    switch (_liturgicalColor) {
      case 'violet':
      case 'purple':
        return const Color(0xFFEFE8F2);
      case 'white':
      case 'gold':
        return const Color(0xFFF5EFE3);
      case 'red':
        return const Color(0xFFF5E1E1);
      case 'rose':
        return const Color(0xFFF9E8EC);
      case 'green':
      default:
        return const Color(0xFFEAF1EB);
    }
  }
}
