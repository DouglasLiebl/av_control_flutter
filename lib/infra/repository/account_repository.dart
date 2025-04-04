import 'package:demo_project/infra/dto/aviary_dto.dart';

abstract class AccountRepository {

  Future<AviaryDto> registerNewAviary(String accountId, String name, String alias);
}