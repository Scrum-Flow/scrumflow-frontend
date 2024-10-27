import 'package:flutter/material.dart';
import 'package:scrumflow/domain/basics/basics.dart';
import 'package:scrumflow/utils/utils.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);

class BaseGrid<T> extends StatelessWidget {
  const BaseGrid({
    required this.items,
    required this.itemBuilder,
    this.maxCrossAxisExtent = 350,
    this.mainAxisExtent = 200,
    this.pageState,
    this.shrinkWrap = false,
    this.padding,
    this.onRefresh,
    super.key,
  });

  final PageState? pageState;
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final Function? onRefresh;
  final double maxCrossAxisExtent;
  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    if (pageState != null) {
      switch (pageState!.status) {
        case PageStatus.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case PageStatus.error:
          return const Center(
            child: BaseLabel(
              text: 'Houve um problema ao carregar os dados',
              fontSize: fsBig,
            ),
          );
        case PageStatus.success:
        case PageStatus.none:
          break;
      }
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BaseLabel(
              text: 'Ops! Nenhum item encontrado',
              fontSize: fsBig,
            ),
            12.toSizedBoxH(),
            GestureDetector(
              onTap: () => onRefresh?.call(),
              child: BaseLabel(
                text: 'Tentar novamente',
                color: Colors.blue,
                decoration: TextDecoration.overline,
                fontSize: fsBig,
              ),
            )
          ],
        ),
      );
    }

    Widget widget = GridView.builder(
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        mainAxisExtent: mainAxisExtent,
        childAspectRatio: 1.5,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemBuilder: (context, index) => itemBuilder.call(context, items[index]),
    );

    if (onRefresh != null) {
      widget = RefreshIndicator(
        onRefresh: () => onRefresh?.call(),
        child: widget,
      );
    }

    return widget;
  }
}
