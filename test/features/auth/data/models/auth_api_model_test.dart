import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_care/features/auth/data/models/auth_api_model.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthApiModel', () {
    const tId = '123456';
    const tUsername = 'testuser';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    final tAuthApiModel = AuthApiModel(
      id: tId,
      username: tUsername,
      email: tEmail,
      password: tPassword,
    );

    final tJson = {
      '_id': tId,
      'username': tUsername,
      'email': tEmail,
      'password': tPassword,
    };

    const tAuthEntity = AuthEntity(
      username: tUsername,
      email: tEmail,
      password: tPassword,
    );

    test('should create AuthApiModel with all fields', () {
      // arrange & act
      final model = AuthApiModel(
        id: tId,
        username: tUsername,
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(model.id, tId);
      expect(model.username, tUsername);
      expect(model.email, tEmail);
      expect(model.password, tPassword);
    });

    test('should properly deserialize from JSON', () {
      // act
      final result = AuthApiModel.fromJson(tJson);

      // assert
      expect(result.id, tId);
      expect(result.username, tUsername);
      expect(result.email, tEmail);
      expect(result.password, tPassword);
    });

    test('should properly serialize to JSON', () {
      // act
      final result = tAuthApiModel.toJson();

      // assert
      expect(result, tJson);
    });

    test('should convert to AuthEntity correctly', () {
      // act
      final result = tAuthApiModel.toEntity();

      // assert
      expect(result.username, tUsername);
      expect(result.email, tEmail);
      expect(result.password, tPassword);
    });

    test('should create AuthApiModel from AuthEntity', () {
      // act
      final result = AuthApiModel.fromEntity(tAuthEntity);

      // assert
      expect(result.username, tUsername);
      expect(result.email, tEmail);
      expect(result.password, tPassword);
    });
  });
}