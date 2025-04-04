import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';

class AllotmentService {
  final AllotmentRepository allotmentRepository;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;

  AllotmentService({required this.allotmentRepository, required this.secureStorage});
}