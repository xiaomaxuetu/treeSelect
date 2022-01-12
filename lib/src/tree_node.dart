import 'package:flutter/material.dart';
import 'package:tree_select/src/node.dart';
import 'package:tree_select/src/tree_view.dart';

class TreeNode extends StatefulWidget {
  final Node node;

  const TreeNode({Key? key, required this.node}) : super(key: key);
  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> {
  @override
  Widget build(BuildContext context) {
    var _treeView = TreeView.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (_treeView!.onNodeClick != null) {
              _treeView.onNodeClick!(widget.node);
            }
          },
          child: Container(
            alignment: Alignment.centerLeft,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.node.children.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          _treeView!.onExpansionChanged!(
                              widget.node.key, !widget.node.expanded);
                        },
                        child: widget.node.expanded
                            ? const Icon(Icons.arrow_drop_down)
                            : const Icon(Icons.arrow_drop_up),
                      )
                    : Container(),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          _treeView!.onNodeCheckChanged!(
                              widget.node.key, !widget.node.checked);
                        },
                        child: Icon(
                          _iconRender(),
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.node.label,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        ClipRect(
          child: Visibility(
            visible: widget.node.expanded,
            maintainState: true,
            child: Align(
              heightFactor: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.node.children
                      .map((e) => TreeNode(node: e))
                      .toList(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TreeNode oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  IconData _iconRender() {
    if (widget.node.isHalf == true) {
      return Icons.indeterminate_check_box;
    }
    if (widget.node.checked == true && widget.node.isHalf == false) {
      return Icons.check_box_outlined;
    }
    if (widget.node.checked == false && widget.node.isHalf == false) {
      return Icons.check_box_outline_blank;
    }

    return Icons.check_box_outlined;
  }
}
