import 'package:tree_select/src/util.dart';

class Node {
  final String key;
  final String label;
  final bool expanded;
  bool checked;
  bool isHalf;
  List<Node> children;
  final bool parent;
  String? parentKey;
  dynamic data;

  Node(
      {required this.key,
      required this.label,
      this.expanded = true,
      this.checked = false,
      this.parent = false,
      this.children = const [],
      this.isHalf = false,
      this.parentKey = "",
      this.data});

  static Node fromMap(Map<String, dynamic> map) {
    String? _key = map['key'];
    String _label = map['label'];
    List<Node> _children = [];
    _key ??= Util.generateRandom();
    if (map['children'] != null) {
      List<Map<String, dynamic>> _childrenMap = List.from(map['children']);
      _children = _childrenMap
          .map((Map<String, dynamic> child) => Node.fromMap(child))
          .toList();
    }
    return Node(
      key: _key,
      label: _label,
      expanded: Util.truthful(map['expanded']),
      children: _children,
    );
  }

  toJson() {
    Map<String, dynamic> map = {};
    map['key'] = key;
    map['label'] = label;
    map['expanded'] = expanded;
    map['checked'] = checked;
    map['isHalf'] = isHalf;
    map['children'] = children.map((e) => e.toJson()).toList();
    map['parent'] = parent;
    map['data'] = data;
    return map;
  }

  Node copyWith(
          {String? key,
          String? label,
          List<Node>? children,
          bool? expanded,
          bool? parent,
          bool? checked,
          bool? isHalf,
          dynamic data}) =>
      Node(
          key: key ?? this.key,
          label: label ?? this.label,
          expanded: expanded ?? this.expanded,
          parent: parent ?? this.parent,
          children: children ?? this.children,
          checked: checked ?? this.checked,
          isHalf: isHalf ?? this.isHalf,
          data: data ?? this.data);

  bool get isParent => children.isNotEmpty || parent;

  //树转数组
  static dfs(Node node, List<Node> list) {
    list.add(node);
    if (node.children.isNotEmpty) {
      for (var e in node.children) {
        e.parentKey = node.key;
        dfs(e, list);
      }
    }
  }

  //数组转树
  static Node ds(List<Node> list) {
    //找出根节点
    late Node root;
    for (var e in list) {
      if (e.parentKey!.isEmpty) {
        root = e;
      }
    }

    root.children = arr2Tree(list, root.key);

    return root;
  }

  static List<Node> arr2Tree(List<Node> list, String parentKey) {
    List<Node> res = [];
    for (var e in list) {
      if (e.parentKey == parentKey) {
        var itemChildren = arr2Tree(list, e.key);
        if (itemChildren.isNotEmpty) {
          e.children = itemChildren;
        }
        res.add(e);
      }
    }
    return res;
  }
  //寻找当前节点的所有父节点和儿子节点

  static Set<Node> findParentAndSon(Node target, List<Node> sourceList) {
    Set<Node> targetList = {};
    findParent(target, sourceList, targetList);
    findSon(target, sourceList, targetList);
    return targetList;
  }

  static findParent(Node target, List<Node> sourceList, Set<Node> targetList) {
    if (target.parentKey!.isNotEmpty) {
      for (var e in sourceList) {
        if (e.key == target.parentKey) {
          targetList.add(e);
          findParent(e, sourceList, targetList);
        }
      }
    }
  }

  static findSon(Node target, List<Node> sourceList, Set<Node> targetList) {
    for (var e in sourceList) {
      if (e.parentKey == target.key) {
        targetList.add(e);
        findSon(e, sourceList, targetList);
      }
    }
  }
}
