import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tree_pro/flutter_tree_pro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TreeView with CheckBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter TreeView with CheckBox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> treeListData = [];
  List<Map<String, dynamic>> initialTreeData = [
    {"parentId": 193, "value": "بوشهر ", "id": 797},
    {"parentId": 193, "value": "دیلم ", "id": 832},
    {"parentId": 193, "value": "عسلویه ", "id": 833},
    {"parentId": 203, "value": "کازرون ", "id": 800}
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var response = await rootBundle.loadString('assets/data.json');
    setState(() {
      json.decode(response)['country'].forEach((item) {
        treeListData.add(item);
      });
    });
  }

  bool isRTL = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: treeListData.isNotEmpty
          ? Column(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Selected IDs'),
                            content: Text(initialTreeData.isNotEmpty
                                ? initialTreeData
                                    .map((item) => item['id'].toString())
                                    .join(', ')
                                : ''),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Show Selected IDs'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'RTL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CupertinoSwitch(
                        value: isRTL,
                        onChanged: (value) {
                          setState(() {
                            isRTL = value;
                          });
                        },
                        activeColor: Colors.indigo,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlutterTreePro(
                      isRTL: isRTL,
                      isExpanded: isExpanded,
                      listData: treeListData,
                      initialListData: initialTreeData,
                      config: const Config(
                          parentId: 'parentId',
                          dataType: DataType.DataList,
                          label: 'value'),
                      onChecked: (List<Map<String, dynamic>> checkedList) {
                        // logger.t(checkedList);
                        // initialTreeData = checkedList;
                      },
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
