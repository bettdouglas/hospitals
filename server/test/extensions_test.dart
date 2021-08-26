import 'package:hospitals/src/extensions.dart';
import 'package:test/test.dart';

void main() {
  group('String extensions test', () {
    test('capitalizeFirstLetter ', () {
      final c = 'uncapitalized frist';
      expect(c.capitalizeFirstLetter, 'Uncapitalized first');
    });
  });
}
