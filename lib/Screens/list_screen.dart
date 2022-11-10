import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthcare_mania_v2/database/database_helper.dart';
import 'package:healthcare_mania_v2/models/models.dart';
import 'package:sqflite/sqlite_api.dart';


class ListScreen extends StatefulWidget {
  static String id = 'list_screen';
  @override
  State<StatefulWidget> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Models> modelsList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (modelsList == null) {
      modelsList = <Models>[];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY HEALTHCARE DATA'),
      ),

      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {

          return Card(
            color: Colors.white,
            elevation: 5.0,

            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                getPriorityColor(modelsList[position].priority),
                child: getPriorityIcon(modelsList[position].priority),
              ),

              title: Text('受診日 : ' + this.modelsList[position].on_the_day),
              subtitle: Text('更新日' + this.modelsList[position].date),
              trailing: GestureDetector(
                child: const Icon(
                  Icons.auto_stories,
                  color: Colors.grey,
                ),
                onTap: () {

                  //削除メソッド
                  _delete(context, modelsList[position]);
                  //遷移メソッド
                  navigateToDetail(modelsList[position], '削除');
                },
              ),
              onTap: () {
                navigateToDetail(modelsList[position], '参照・訂正');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          //コンストラクターに初期値をセットする
          navigateToDetail(Models(1, ''), '新規登録');
        },
        tooltip: '新規登録',
        child: const Icon(Icons.add),
      ),
    );
  }


  //選択の種類によって色とアイコンを変える仕組み
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
      //type = "定期";
        return Colors.red;
      case 2:
      //type = "その他";
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);


      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  //削除
  void _delete(BuildContext context, Models models) async {
    int result = await databaseHelper.deleteModels(models.id);
    if (result != 0) {
      //スナックバーで表示、のメソッド
      _showSnackBar(context, '削除完了');
      //画面更新のメソッドへジャンプ
      updateListView();
    }
  }

//
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

//
  void navigateToDetail(Models models, String height) async {
    bool result = await Navigator.push(MaterialApp:(context) => PreviwScreen());
    if (result == true) {
      updateListView();
    }
  }

//リストビューの更新
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Models>> noteListFuture = databaseHelper.getModelsList();
      noteListFuture.then((noteList) {
        setState(() {
          this.modelsList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
