import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrumflow/domain/pages/pages.dart';
import 'package:scrumflow/domain/pages/user/services/services.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/models/user_role.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/widgets.dart';

class UserListController extends GetxController {
  List<User>? _users;

  List<User> values = [];
  List<UserRole> roles = [];
  Rx<PageState> userListState = PageState.none().obs;
  Rx<PageState> userState = PageState.none().obs;
  Rx<PageState> userPatchState = PageState.none().obs;
  RxString filterValue = ''.obs;
  PageController controller = PageController();

  @override
  void onInit() {
    fetchUsers();

    userState.listen(Prompts.showSnackBar);
    userPatchState.listen(Prompts.showSnackBar);

    super.onInit();
  }

  FutureOr<void> fetchUsers() async {
    userListState.value = PageState.loading();

    AuthController authController = Get.find<AuthController>();

    _users = await UserService.getUsers();
    roles = await UserService.userRoles();

    values = _users ?? [];

    values.removeWhere((u) => u.id == authController.user.value.id);

    userListState.value = PageState.none();
  }

  FutureOr<void> updateUserCategory(User user, List<UserRole>? roles) async {
    userListState.value = PageState.loading();

    try {
      int index = values.indexOf(user);

      values.removeAt(index);

      User newUser =
          await UserService.updateUserRoles(user.copyWith(roles: roles));

      values.insert(index, newUser);

      userListState.value = PageState.none();
    } catch (e) {
      userState.value =
          PageState.error('Falha ao atualizar categoria do usuário!');
    }
  }

  FutureOr<void> patchUserNotification(int userId, bool notifyUser) async {
    userPatchState.value = PageState.none();
    try {
      await UserService.patchUserNotification(userId, notifyUser);

      userPatchState.value = PageState.success(data: "Notificação atualizada");
    } catch (e) {
      userPatchState.value =
          PageState.error('Falha ao atualizar as notificações do usuário!');
    }
  }

  void filterUsers() {
    userListState.value = PageState.loading();

    values = (_users ?? [])
        .where((element) => (element.name?.toLowerCase() ?? '')
            .isCaseInsensitiveContains(filterValue.value.toLowerCase()))
        .toList();

    userListState.value = PageState.none();
  }

  void filterSubmitted(String filter) {
    filterValue.value = filter;
    filterUsers();
  }
}
