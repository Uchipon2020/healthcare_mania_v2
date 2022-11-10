import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/material/icon_button.dart';
import 'package:flutter/widgets.dart';
import 'package:healthcare_mania_v2/database/database_helper.dart';
import 'package:healthcare_mania_v2/models/models.dart';

class PreviewScreen extends StatefulWidget {
  static String id = 'preview_screen';
  const PreviewScreen({Key? key}) : super(key: key);
  @override

  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  static var  _priorities = ['定期', 'その他'];
  DatabaseHelper helper = DatabaseHelper();
  late String appBarTitle;
  late Models models;
  dynamic dateNow = '';

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController rEyeController = TextEditingController();
  TextEditingController lEyeController = TextEditingController();
  TextEditingController lBpController = TextEditingController();
  TextEditingController hBpController = TextEditingController();
  TextEditingController onTheDayController = TextEditingController();
  TextEditingController hR1000Controller = TextEditingController();
  TextEditingController hL1000Controller = TextEditingController();
  TextEditingController hR4000Controller = TextEditingController();
  TextEditingController hL4000Controller = TextEditingController();
  TextEditingController xRayController = TextEditingController();
  TextEditingController rBController = TextEditingController();
  TextEditingController hEmoController = TextEditingController();
  TextEditingController gOtController = TextEditingController();
  TextEditingController gPtController = TextEditingController();
  TextEditingController gTpController = TextEditingController();
  TextEditingController lDlController = TextEditingController();
  TextEditingController hDlController = TextEditingController();
  TextEditingController nFatController = TextEditingController();
  TextEditingController bGluController = TextEditingController();
  TextEditingController hA1cController = TextEditingController();
  TextEditingController eCgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    heightController.text = models.height;
    weightController.text = models.weight;
    rEyeController.text = models.right_eye;
    lEyeController.text = models.left_eye;
    lBpController.text = models.low_blood_pressure;
    hBpController.text = models.high_blood_pressure;
    onTheDayController.text = models.on_the_day;
    hR1000Controller.text = models.hearing_right_1000;
    hL1000Controller.text = models.hearing_left_1000;
    hR4000Controller.text = models.hearing_right_4000;
    hL4000Controller.text = models.hearing_left_4000;
    xRayController.text = models.x_ray;
    rBController.text = models.red_blood;
    hEmoController.text = models.hemoglobin;
    gOtController.text = models.got;
    gPtController.text = models.gpt;
    gTpController.text = models.gpt;
    lDlController.text = models.ldl;
    hDlController.text = models.hdl;
    nFatController.text = models.neutral_fat;
    bGluController.text = models.blood_glucose;
    hA1cController.text = models.hA1c;
    eCgController.text = models.ecg;

    return Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: [
                //エレメント１，プルダウンの項目選択
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(models.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),
                // 8 Element　受診日
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _selectDate(context);
                          onTheDayController.text = dateNow;
                          updateOTD();
                        },
                        icon: Icon(Icons.calendar_today_outlined),
                      ),
                      Text(
                        dateNow.toString(),
                      ),
                    ],
                  ),
                ),

                // Second Element　身長入力
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 2.5),
                  child: TextField(
                    controller: heightController,
                    style: textStyle,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateHeight();
                    },
                    decoration: InputDecoration(
                        labelText: '身長',
                        labelStyle: textStyle,
                        suffix: Text(' cm'),
                        icon: Icon(Icons.accessibility),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element　体重入力
                Padding(
                  padding: EdgeInsets.only(top: 2.5, bottom: 10.0),
                  child: TextField(
                    controller: weightController,
                    style: textStyle,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateWeight();
                    },
                    decoration: InputDecoration(
                        labelText: '体重',
                        labelStyle: textStyle,
                        suffix: Text(' kg'),
                        icon: Icon(Icons.accessibility),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //視力横並び表示-------------------
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 3 Element　（右）視力入力
                        child: TextField(
                          controller: rEyeController,
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateREye();
                          },
                          decoration: InputDecoration(
                            labelText: '右視力',
                            icon: Icon(Icons.remove_red_eye),
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 5 Element　（左）視力入力
                        child: TextField(
                          controller: lEyeController,
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateLEye();
                          },
                          decoration: InputDecoration(
                            labelText: '左視力',
                            icon: Icon(Icons.remove_red_eye),
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //聴力1000Hz

                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 2.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 3 Element　聴力1000Hz　右
                        child: TextField(
                          controller: hR1000Controller,
                          style: textStyle,
                          //keyboardType:TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHearing_r_1000();
                          },

                          decoration: InputDecoration(
                            labelText: '右聴力1000',
                            labelStyle: textStyle,
                            icon: Icon(Icons.hearing),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 5 Element　聴力1000　左
                        child: TextField(
                          controller: hL1000Controller,
                          style: textStyle,
                          // keyboardType:TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHearing_l_1000();
                          },
                          decoration: InputDecoration(
                            labelText: '左聴力1000',
                            labelStyle: textStyle,
                            icon: Icon(Icons.hearing),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //聴力4000Hz

                Padding(
                  padding: EdgeInsets.only(top: 2.5, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 3 Element　聴力4000Hz　右
                        child: TextField(
                          controller: hR4000Controller,
                          style: textStyle,
                          //keyboardType:TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHearing_r_4000();
                          },

                          decoration: InputDecoration(
                            labelText: '右聴力4000',
                            icon: Icon(Icons.hearing),
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 5 Element　聴力4000　左
                        child: TextField(
                          controller: hL4000Controller,
                          style: textStyle,
                          //keyboardType:TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHearing_l_4000();
                          },
                          decoration: InputDecoration(
                            labelText: '左聴力4000',
                            labelStyle: textStyle,
                            icon: Icon(Icons.hearing),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //血圧横並び表示----------------
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 6 Element　血圧（LOW）
                        child: TextField(
                          controller: lBpController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateLBp();
                          },
                          decoration: InputDecoration(
                              labelText: '血圧Low',
                              labelStyle: textStyle,
                              suffix: Text(' mmHg'),
                              icon: Icon(Icons.arrow_downward),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 7 Element　血圧（High）
                        child: TextField(
                          controller: hBpController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHBp();
                          },
                          decoration: InputDecoration(
                              labelText: '血圧High',
                              labelStyle: textStyle,
                              suffix: Text(' mmHg'),
                              icon: Icon(Icons.arrow_upward),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                    ],
                  ),
                ),

                // x線検査
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: xRayController,
                    style: textStyle,
                    //keyboardType:TextInputType.number,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateXray();
                    },
                    decoration: InputDecoration(
                        labelText: 'レントゲン検査所見',
                        icon: Icon(Icons.content_paste),
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // 心電図検査

                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: eCgController,
                    style: textStyle,
                    //keyboardType:TextInputType.number,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateEcg();
                    },
                    decoration: InputDecoration(
                        labelText: '心電図検査所見',
                        labelStyle: textStyle,
                        icon: Icon(Icons.accessibility),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /*
                //赤血球数・血色素量----------------
                /
                 -------------------------------------- */
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 2.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 6 Element　赤血球数
                        child: TextField(
                          controller: rBController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateRedblood();
                          },
                          decoration: InputDecoration(
                              labelText: '赤血球数',
                              labelStyle: textStyle,
                              suffix: Text(' 万/μL'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 7 Element　血色素量
                        child: TextField(
                          controller: hEmoController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHemo();
                          },
                          decoration: InputDecoration(
                              labelText: '血色素量',
                              labelStyle: textStyle,
                              suffix: Text(' g/dL'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                    ],
                  ),
                ),

                //肝機能検査　横並び３つ----------------
                Padding(
                  padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // ＧＯＴ
                        child: TextField(
                          controller: gOtController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateGot();
                          },
                          decoration: InputDecoration(
                              labelText: 'ＧＯＴ',
                              labelStyle: textStyle,
                              suffix: Text(' U/L'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // ＧＰＴ
                        child: TextField(
                          controller: gPtController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateGpt();
                          },
                          decoration: InputDecoration(
                              labelText: 'ＧＰＴ',
                              labelStyle: textStyle,
                              suffix: Text(' U/L'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // ガンマ
                        child: TextField(
                          controller: gTpController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateGtp();
                          },
                          decoration: InputDecoration(
                              labelText: 'ガンマGPT',
                              labelStyle: textStyle,
                              suffix: Text(' U/L'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                    ],
                  ),
                ),

                //ＬＤＬとＨＤＬ----------------
                Padding(
                  padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // LDL
                        child: TextField(
                          controller: lDlController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateLdl();
                          },
                          decoration: InputDecoration(
                              labelText: 'ＬＤＬ',
                              labelStyle: textStyle,
                              suffix: Text(' mg/dL'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // ＨＤＬ
                        child: TextField(
                          controller: hDlController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHdl();
                          },
                          decoration: InputDecoration(
                              labelText: 'ＨＤＬ',
                              labelStyle: textStyle,
                              suffix: Text(' mg/dL'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // 中性脂肪
                        child: TextField(
                          controller: nFatController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateNeutralfat();
                          },
                          decoration: InputDecoration(
                              labelText: '中性脂肪',
                              labelStyle: textStyle,
                              suffix: Text(' mg/dL'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                    ],
                  ),
                ),

                //血糖検査

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // 空腹時血糖
                        child: TextField(
                          controller: bGluController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateBloodglucose();
                          },
                          decoration: InputDecoration(
                            labelText: '空腹時血糖',
                            labelStyle: textStyle,
                            suffix: Text(' mg/dL'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // A1c
                        child: TextField(
                          controller: hA1cController,
                          style: textStyle,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text Field');
                            updateHA1c();
                          },
                          decoration: InputDecoration(
                            labelText: 'hA1c',
                            labelStyle: textStyle,
                            suffix: Text(' %'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /* 5 Element　保存と削除　横並び表示
                *
                *
                *
                *
                *
                * ---------------------------------------------- */
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  void moveToLastScreen() {
    Navigator.pop(context [true]);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case '定期':
        models.priority = 1;
        break;
      case 'その他':
        models.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateHeight() {
    models.height = heightController.text;
  }

  // Update the title of Note object
  void updateWeight() {
    models.weight = weightController.text;
  }

  // Update the right_eyes of Note object
  void updateREye() {
    models.right_eye = rEyeController.text;
  }

  // Update the left_eyes of Note object
  void updateLEye() {
    models.left_eye = lEyeController.text;
  }

  void updateHearing_r_1000() {
    models.hearing_right_1000 = hR1000Controller.text;
  }

  void updateHearing_l_1000() {
    models.hearing_left_1000 = hL1000Controller.text;
  }

  void updateHearing_r_4000() {
    models.hearing_right_4000 = hR4000Controller.text;
  }

  void updateHearing_l_4000() {
    models.hearing_left_4000 = hL4000Controller.text;
  }

  void updateXray() {
    models.x_ray = xRayController.text;
  }

  void updateRedblood() {
    models.red_blood = rBController.text;
  }

  void updateHemo() {
    models.hemoglobin = hEmoController.text;
  }

  void updateGot() {
    models.got = gOtController.text;
  }

  void updateGpt() {
    models.gpt = gPtController.text;
  }

  void updateGtp() {
    models.gtp = gTpController.text;
  }

  void updateLdl() {
    models.ldl = lDlController.text;
  }

  void updateHdl() {
    models.hdl = hDlController.text;
  }

  void updateNeutralfat() {
    models.neutral_fat = nFatController.text;
  }

  void updateBloodglucose() {
    models.blood_glucose = bGluController.text;
  }

  void updateHA1c() {
    models.hA1c = hA1cController.text;
  }

  void updateEcg() {
    models.ecg = eCgController.text;
  }

  // Update the low_blood_pressure of Note object
  void updateLBp() {
    models.low_blood_pressuer = lBpController.text;
  }

  // Update the high_blood_pressure of Note object
  void updateHBp() {
    models.high_blood_pressuer = hBpController.text;
  }

  // Update the on_the_day of Note object
  void updateOTD() {
    models.on_the_day = onTheDayController.text;
  }

/*  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: new DateTime.now().add(new Duration(days: 720)));
    if (selected != null) {
      setState(() => this.dateNow = selected);
      debugPrint('$dateNow');
      //note.on_the_day = onTheDayController.text;
    }
  }*/

  // Save data to database
  void _save() async {
    moveToLastScreen();

    models.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (models.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(models);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(models);
    }

    result  != 0 ? _showAlertDialog('状況', '保存完了！！') :
    _showAlertDialog('状況', '問題発生・保存されませんでした');
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (models.id == null) {
      _showAlertDialog('状況', '削除データなし');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteModels(models.id);
    result != 0 ?
    _showAlertDialog('状況', 'データ削除完了'):
    _showAlertDialog('状況', '問題発生・データ削除不可');
  }
}

void _showAlertDialog(String title, String message) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: , builder: builder)
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
