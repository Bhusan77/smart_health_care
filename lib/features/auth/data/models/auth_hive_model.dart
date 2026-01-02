import 'package:hive/hive.dart';
import 'package:smart_health_care/core/constants/hive_table_constant.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? password;
  
  AuthHiveModel({
    String? authId,
    
    required this.email,
    
    this.password,
    
  }) : authId = authId ?? const Uuid().v4();

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      
      email: email,
      
      password: password,
      
    );
  }

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
     
      email: entity.email,
      
      password: entity.password,
      
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}