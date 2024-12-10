import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/domain/pages/user/controllers/user_list_controller.dart';
import 'package:scrumflow/models/models.dart';
import 'package:scrumflow/models/user_role.dart';
import 'package:scrumflow/utils/utils.dart';
import 'package:scrumflow/widgets/notification_dialog.dart';
import 'package:scrumflow/widgets/widgets.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    UserListController userListController =
        Get.put<UserListController>(UserListController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            SearchField(
              onFieldSubmitted: userListController.filterSubmitted,
              onClear: userListController.filterSubmitted,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: BaseLabel(
                        text: 'Usuários',
                        fontSize: fsVeryBig,
                        fontWeight: fwMedium,
                      ),
                    ),
                    Expanded(child: _UserList()), // Mover Expanded aqui
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<UserListController>();
    super.dispose();
  }
}

class _UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserListController controller = Get.find<UserListController>();

    return Obx(
      () => BaseGrid(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 200,
        onRefresh: () => controller.fetchUsers(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24)
            .add(const EdgeInsets.only(bottom: 12)),
        pageState: controller.userListState.value,
        items: controller.values,
        itemBuilder: (context, item) => UserCard(item),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    UserListController controller = Get.find<UserListController>();

    return Obx(
      () => LoadingWidget(
        isLoading: controller.userState.value.status == PageStatus.loading,
        child: Card(
          shadowColor: Colors.black45,
          elevation: 2,
          color: Colors.grey[250],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(
                                    (Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: BaseLabel(
                          text: user.toString(),
                          color: Colors.black,
                          fontWeight: fwBold,
                        ),
                      ),
                    ),
                    NotificationDialog(user.id!, false

                        ///TODO: alterar aqui
                        ),
                  ],
                ),
                12.toSizedBoxH(),
                MultiSelectDialogField<UserRole>(
                  initialValue: user.roles ?? [],
                  buttonText: Text('Categorias'),
                  title: BaseLabel(text: 'Categorias'),
                  items: controller.roles
                      .map((e) => MultiSelectItem(e, e.name ?? ''))
                      .toList(),
                  onConfirm: (categories) =>
                      controller.updateUserCategory(user, categories),
                  chipDisplay: MultiSelectChipDisplay(
                    scroll: true,
                    textStyle: TextStyle(fontSize: fsSmall),
                    scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                  ),
                  listType: MultiSelectListType.CHIP,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
