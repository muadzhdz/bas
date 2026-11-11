import 'package:bas/api/news_api.dart';
import 'package:bas/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsModel and NewsApi Unit Tests', () {
    test('NewsModel.fromJson parses raw JSON correctly', () {
      final jsonMap = {
        'judul_berita': 'Seminar Nasional AI',
        'isi_berita': 'Seminar ini membahas masa depan kecerdasan buatan.',
        'tgl_posting_berita': '2026-11-01',
        'berita_dari': 'Humas Kampus',
      };

      final model = NewsModel.fromJson(jsonMap);

      expect(model.judul, equals('Seminar Nasional AI'));
      expect(
        model.isi,
        equals('Seminar ini membahas masa depan kecerdasan buatan.'),
      );
      expect(model.tanggalPosting, equals('2026-11-01'));
      expect(model.sumber, equals('Humas Kampus'));

      final jsonOut = model.toJson();
      expect(jsonOut['judul_berita'], equals('Seminar Nasional AI'));
      expect(jsonOut['berita_dari'], equals('Humas Kampus'));
    });

    test('Live fetchNews from MockAPI returns list of news', () async {
      final api = NewsApi();
      final list = await api.fetchNews();

      expect(list, isA<List<NewsModel>>());
      if (list.isNotEmpty) {
        expect(list.first.judul.isNotEmpty, isTrue);
      }
    });
  });
}
