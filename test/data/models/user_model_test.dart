import 'package:flutter_test/flutter_test.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';

void main() {
  group('UserModel', () {
    final tUserModel = UserModel(
      uid: '123',
      fullName: 'Test User',
      email: 'test@example.com',
      uf: 'SP',
      cidade: 'São Paulo',
    );

    test('should support value equality', () {
      final user1 = UserModel(uid: '1', uf: 'RJ');
      final user2 = UserModel(uid: '1', uf: 'RJ');
      expect(user1, equals(user2));
    });

    test('copyWith should return a valid model with updated values', () {
      final result = tUserModel.copyWith(uf: 'RJ');
      expect(result.uf, 'RJ');
      expect(result.fullName, tUserModel.fullName);
    });

    test('toFirestore should return a JSON map containing new uf field', () {
      final result = tUserModel.toFirestore();
      expect(result['uf'], 'SP');
      expect(result['cidade'], 'São Paulo');
    });

    test('fromJson should return a valid model from JSON', () {
      final json = {
        'uid': '123',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'uf': 'MG',
        'cidade': 'Belo Horizonte',
      };
      final result = UserModel.fromJson(json);
      expect(result.uf, 'MG');
      expect(result.cidade, 'Belo Horizonte');
    });
  });
}
