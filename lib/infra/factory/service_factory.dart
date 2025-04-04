import 'package:demo_project/domain/service/account_service.dart';
import 'package:demo_project/domain/service/allotment_service.dart';
import 'package:demo_project/domain/service/auth_service.dart';
import 'package:demo_project/infra/factory/repository_factory.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/main.dart';

class ServiceFactory {
  AuthService? authService;
  AccountService? accountService;
  AllotmentService? allotmentService;

  AuthService getAuthService() {
    if (authService != null) return authService!;
    authService = AuthService(
      authRepository: getIt<RepositoryFactory>().getAuthRepository(), 
      secureStorage: getIt<SecureStorage>()
    );
    return authService!; 
  }

  AccountService getAccountService() {
    if (accountService != null) return accountService!;
    accountService = AccountService(
      accountRepository: getIt<RepositoryFactory>().getAccountRepository(), 
      secureStorage: getIt<SecureStorage>()
    );
    return accountService!;
  }

  AllotmentService getAllotmentService() {
    if (allotmentService != null) return allotmentService!;
    allotmentService = AllotmentService(
      allotmentRepository: getIt<RepositoryFactory>().getAllotmentRepository(), 
      secureStorage: getIt<SecureStorage>()
    );
    return allotmentService!;
  }
}