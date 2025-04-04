import 'package:demo_project/domain/entity/account.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/domain/service/account_service.dart';
import 'package:demo_project/domain/service/auth_service.dart';
import 'package:demo_project/presentation/provider/base_provider.dart';

class AccountProvider extends BaseProvider {
  final AuthService authService;
  final AccountService accountService;

  AccountProvider({required this.authService, required this.accountService}) {
    _loadContext();
  }

  Account _account = Account(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    aviaries: [],
  );

  Account get getAccount => _account;  

  Future<void> _loadContext() async {
    if (await authService.hasLoggedUser()) {
      _account = await accountService.getAccountData();
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      Account response = await authService.login(email, password);
      _account = response;
    } catch (e, stackTrace) {
      await handleError(e, stackTrace);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
      _account = Account(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      aviaries: [],
    );
  }

  Future<void> registerAviary(String name, String alias) async {
    Aviary response = await accountService.registerNewAviary(_account.id, name, alias);
    _account.aviaries.add(response);

    notifyListeners();
  }


  Future<void> updateActiveAllotmentId(String aviaryId, String allotmentId) async {
    for (var a in _account.aviaries) {
      if (a.id == aviaryId) {
        a.activeAllotmentId = allotmentId;
      }
    }

    notifyListeners(); 
  }

  Future<void> reloadContext() async {
    await _loadContext();
  }

  Aviary getAviaryById(String id) {
    return _account.aviaries.firstWhere((aviary) => aviary.id == id);
  }

  List<Aviary> getAviaries() {
    return _account.aviaries;
  }

}