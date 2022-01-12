import 'package:flutter/material.dart';
import 'package:tree_select/src/tree_view_controller.dart';

import 'node.dart';
import 'tree_node.dart';

class TreeView extends InheritedWidget {
  final TreeViewController controller;
  final Function(String, bool)? onExpansionChanged;
  final Function(String, bool)? onNodeCheckChanged;
  final Function(Node node)? onNodeClick;

  TreeView(
      {Key? key,
      required this.controller,
      this.onExpansionChanged,
      this.onNodeCheckChanged,
      this.onNodeClick})
      : super(
            key: key,
            child: _TreeViewData(
              controller,
            ));

  static TreeView? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);
  @override
  bool updateShouldNotify(TreeView oldWidget) {
    return oldWidget.controller != controller;
  }
}

class _TreeViewData extends StatelessWidget {
  final TreeViewController _controller;

  const _TreeViewData(this._controller);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: _controller.children.map((e) => TreeNode(node: e)).toList(),
    );
  }
}
