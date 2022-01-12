import 'dart:convert';

import 'node.dart';

class TreeViewController {
  final List<Node> children;
  final String selectedKey;
  TreeViewController({this.children = const [], required this.selectedKey});

  TreeViewController copyWith({List<Node>? children, String? selectedKey}) {
    return TreeViewController(
      children: children ?? this.children,
      selectedKey: selectedKey ?? this.selectedKey,
    );
  }

  TreeViewController loadJSON<T>({String json = '[]'}) {
    List jsonList = jsonDecode(json);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);
    return loadMap<T>(list: list);
  }

  TreeViewController loadMap<T>({List<Map<String, dynamic>> list = const []}) {
    List<Node> treeData =
        list.map((Map<String, dynamic> item) => Node.fromMap(item)).toList();
    return TreeViewController(
      children: treeData,
      selectedKey: selectedKey,
    );
  }

  TreeViewController withUpdateNode<T>(String key, Node newNode,
      {Node? parent}) {
    List<Node> _data = updateNode<T>(key, newNode, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: selectedKey,
    );
  }

  List<Node> updateNode<T>(String key, Node newNode, {Node? parent}) {
    List<Node> _children = parent == null ? children : parent.children;
    return _children.map((Node child) {
      if (child.key == key) {
        return newNode;
      } else {
        if (child.isParent) {
          return child.copyWith(
            children: updateNode(
              key,
              newNode,
              parent: child,
            ),
          );
        }
        return child;
      }
    }).toList();
  }

  Node? getNode<T>(String key, {Node? parent}) {
    Node? _found;
    List<Node> _children = parent == null ? children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key == key) {
        _found = child;
        break;
      } else {
        if (child.isParent) {
          _found = getNode(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  Node? getParent(String key, {Node? parent}) {
    Node? _found;
    List<Node> _children = parent == null ? children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      Node child = iter.current;
      if (child.key == key) {
        _found = parent ?? child;
        break;
      } else {
        if (child.isParent) {
          _found = getParent(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  List<Node> getAllLeaf() {
    List<Node> leafnodes = [];
    for (var element in children) {
      if (!element.isParent) {
        leafnodes.add(element);
      } else {
        parseTree(element, leafnodes);
      }
    }

    return leafnodes.where((element) => element.checked == true).toList();
  }

  parseTree(Node node, List<Node> leafnodes) {
    if (node.isParent) {
      for (var element in node.children) {
        parseTree(element, leafnodes);
      }
    } else {
      leafnodes.add(node);
    }
  }
}
