import 'package:bas/api/finance_api.dart';
import 'package:bas/models/finance_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinanceModel and FinanceApi Unit Tests', () {
    test('FinanceModel.fromJson parses raw JSON and formats currency', () {
      final jsonMap = {
        'nid': 52700,
        'npm': '12523030',
        'thn_akademik': '2023/2024',
        'semester': 'ganjil',
        'dpayment': '2023-06-30',
        'npayment': '300000',
        'cketerangan': 'Biaya Pendaftaran Mahasiswa Baru',
        'reg_id': 'RG237039',
      };

      final model = FinanceModel.fromJson(jsonMap);

      expect(model.id, equals(52700));
      expect(model.npm, equals('12523030'));
      expect(model.tahunAkademik, equals('2023/2024'));
      expect(model.semester, equals('ganjil'));
      expect(model.tanggalBayar, equals('2023-06-30'));
      expect(model.nominal, equals(300000));
      expect(model.keterangan, equals('Biaya Pendaftaran Mahasiswa Baru'));
      expect(model.regId, equals('RG237039'));
      expect(model.formattedNominal, equals('Rp 300.000'));
    });

    test('Live fetchPaymentsByNpm from MockAPI returns transactions', () async {
      final api = FinanceApi();
      final list = await api.fetchPaymentsByNpm('12523030');

      expect(list, isA<List<FinanceModel>>());
      if (list.isNotEmpty) {
        expect(list.first.nominal > 0, isTrue);
        expect(list.first.formattedNominal.startsWith('Rp '), isTrue);
      }
    });
  });
}
