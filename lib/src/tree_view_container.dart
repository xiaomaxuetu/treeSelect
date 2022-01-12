import 'package:flutter/material.dart';
import 'package:tree_select/src/tree_view.dart';
import 'package:tree_select/src/tree_view_controller.dart';

import 'node.dart';

class TreeViewContainer extends StatefulWidget {
  final List<Node> children;
  final Function(List<Node>)? onCheck;
  final Function(Node)? onNodeClick;
  final bool? showCheckBox;
  final bool? showSearch;

  const TreeViewContainer(
      {Key? key,
      this.onCheck,
      required this.children,
      this.onNodeClick,
      this.showCheckBox = false,
      this.showSearch = false})
      : super(key: key);
  @override
  _TreeViewContainerState createState() => _TreeViewContainerState();
}

class _TreeViewContainerState extends State<TreeViewContainer> {
  late TreeViewController _treeViewController;
  final TextEditingController _textEditingController = TextEditingController();
  String selectNode = "";

  @override
  void initState() {
    super.initState();
    _treeViewController =
        TreeViewController(children: widget.children, selectedKey: '');
  }

  @override
  didUpdateWidget(TreeViewContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // setState(() {
    //   _treeViewController = TreeViewController(children: widget.children);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // height: ScreenUtil.getViewHeight(context) * 8 / 10,
      child: Column(
        children: [
          Expanded(
              flex: 9,
              child: TreeView(
                controller: _treeViewController,
                onExpansionChanged: (key, expanded) {
                  Node? node = _treeViewController.getNode(key);
                  if (node != null) {
                    List<Node> updated;
                    updated = _treeViewController.updateNode(
                        key, node.copyWith(expanded: expanded));

                    setState(() {
                      _treeViewController =
                          _treeViewController.copyWith(children: updated);
                    });
                  }
                },
                onNodeCheckChanged: (key, checked) {
                  Node? node = _treeViewController.getNode(key);

                  if (node != null) {
                    List<Node> updated;
                    parseNode(node, checked);
                    var topNode = parseNodeParent(node, checked);
                    updated =
                        _treeViewController.updateNode(topNode.key, topNode);

                    setState(() {
                      _treeViewController =
                          _treeViewController.copyWith(children: updated);
                      if (widget.onCheck != null) {
                        widget.onCheck!(_treeViewController.getAllLeaf());
                      }
                    });
                  }
                },
                onNodeClick: (node) {
                  if (widget.onNodeClick != null) {
                    widget.onNodeClick!(node);
                  }
                },
              ))
        ],
      ),
    );
  }

  parseNode(Node node, bool checked) {
    node.checked = checked;
    if (node.isParent) {
      for (var element in node.children) {
        parseNode(element, checked);
      }
    }
  }

  parseNodeParent(Node node, bool checked) {
    var parent = _treeViewController.getParent(node.key);
    if (parent != null && parent.key != node.key) {
      parent.checked = checked;
      if (parent.children.every(
          (element) => element.checked == true && element.isHalf == false)) {
        parent.checked = true;
        parent.isHalf = false;
      } else if (parent.children.every(
          (element) => element.checked == false && element.isHalf == false)) {
        parent.checked = false;
        parent.isHalf = false;
      } else {
        parent.isHalf = true;
      }
      return parseNodeParent(parent, checked);
    } else {
      if (parent!.key == node.key) {
        return node;
      }
      if (node.children.every(
          (element) => element.checked == true && element.isHalf == false)) {
        node.checked = true;
        node.isHalf = false;
      } else if (node.children.every(
          (element) => element.checked == false && element.isHalf == false)) {
        node.checked = false;
        node.isHalf = false;
      } else {
        node.isHalf = true;
      }
      return node;
    }
  }

  search(String text) {
    if (text.isEmpty) {
      setState(() {
        _treeViewController =
            TreeViewController(children: widget.children, selectedKey: '');
      });
      return;
    }
    List<Node> list = [];
    // Node copyNode = Node.fromMap(_treeViewController.children.first.toJson());
    // Node.dfs(copyNode, list);
    for (var e in _treeViewController.children) {
      Node copyNode = Node.fromMap(e.toJson());
      Node.dfs(copyNode, list);
    }
    //检索
    var res = list.where((e) => e.label.contains(text)).toList();
    for (var e in res) {
      e.children = [];
    }
    if (res.isNotEmpty) {
      Set<Node> temp = {};
      for (var e in res) {
        temp.addAll(Node.findParentAndSon(e, list));
      }
      // for (var e in temp) {
      //   e.children = [];
      // }
      Node result = Node.ds([...temp.toList()]);
      setState(() {
        _treeViewController = _treeViewController.copyWith(children: [result]);
      });
    }
  }
}
