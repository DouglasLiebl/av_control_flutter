import 'package:demo_project/infra/repository/account_repository.dart';
import 'package:demo_project/infra/repository/allotment_repository.dart';
import 'package:demo_project/infra/repository/auth_repository.dart';
import 'package:demo_project/infra/repository/impl/account_repository_impl.dart';
import 'package:demo_project/infra/repository/impl/allotment_repository_impl.dart';
import 'package:demo_project/infra/repository/impl/auth_repository_impl.dart';
import 'package:demo_project/infra/third_party/api/api_private.dart';
import 'package:demo_project/infra/third_party/api/api_public.dart';
import 'package:dio/dio.dart';

class RepositoryFactory {
  AuthRepository? authRepository;
  AccountRepository? accountRepository;
  AllotmentRepository? allotmentRepository;

  AuthRepository getAuthRepository() {
    if (authRepository != null) return authRepository!;
    authRepository = AuthRepositoryImpl(apiPublic: ApiPublic(dio: Dio()).getInstance());
    return authRepository!;
  }

  AccountRepository getAccountRepository() {
    if (accountRepository != null) return accountRepository!;
    accountRepository = AccountRepositoryImpl(apiPrivate: ApiPrivate(dio: Dio()).getInstance());
    return accountRepository!;
  }

  AllotmentRepository getAllotmentRepository() {
    if (allotmentRepository != null) return allotmentRepository!;
    allotmentRepository = AllotmentRepositoryImpl(apiPrivate: ApiPrivate(dio: Dio()).getInstance());
    return allotmentRepository!;
  }
}