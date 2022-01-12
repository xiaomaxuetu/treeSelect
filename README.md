
# tree_select

树形选择组件

## 使用方法

```
import 'package:flutter/material.dart';

import '../tree_select.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/": (context) => const MyApp()},
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Node> nodes = [
    Node(key: '0', label: '0', children: [
      Node(key: '0_0', label: '0_0', children: [
        Node(key: '0_0_0', label: '0_0_0'),
        Node(key: '0_0_1', label: '0_0_1')
      ]),
      Node(key: '0_1', label: '0_1')
    ]),
    Node(key: '1', label: '1')
  ];
  String checkStr = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("treeSelect"),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 9,
                child: TreeViewContainer(
                  children: nodes,
                  onCheck: (list) {
                    var str = list.map((e) => e.label).join(",");
                    setState(() {
                      checkStr = str;
                    });
                  },
                  onNodeClick: (node) {
                    print("点击了${node.label}");
                  },
                )),
            Expanded(flex: 1, child: Text(checkStr))
          ],
        ),
      ),
    );
  }
}
```



