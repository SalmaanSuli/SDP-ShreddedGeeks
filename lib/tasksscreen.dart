import 'package:endurance_fitness/endurance_animations.dart';
import 'package:endurance_fitness/endurance_theme.dart';
import 'package:endurance_fitness/endurance_util.dart';
import 'package:endurance_fitness/endurance_widgets.dart';

import 'package:endurance_fitness/create_task_new_widget.dart';
import 'package:endurance_fitness/custom_toggle_icon.dart';
import 'package:endurance_fitness/empty_list_tasks_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:endurance_fitness/loginscreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:endurance_fitness/AppTaskClass.dart';

import 'package:endurance_fitness/main.dart';

class MyTasksWidget extends StatefulWidget {
  const MyTasksWidget({Key? key}) : super(key: key);

  @override
  _MyTasksWidgetState createState() => _MyTasksWidgetState();
}

class _MyTasksWidgetState extends State<MyTasksWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      //hideBeforeAnimating: false,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 70),
        scale: 1,
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        scale: 1,
        opacity: 1,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: EnduranceTheme.of(context).secondaryBackground,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/page__bg.jpg',
            ).image,
          ),
          shape: BoxShape.rectangle,
        ),
        child: Scaffold(
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Color(0xFF171717),
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(3, 3, 3, 3),
                  child: Text(
                    '', //'ENDURANCE',
                    textAlign: TextAlign.center,
                    style: EnduranceTheme.of(context).subtitle1.override(
                          fontFamily: 'Outfit',
                          color: EnduranceTheme.of(context).primaryColor,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                actions: [],
                elevation: 2,
              ),
            ),
            backgroundColor: EnduranceTheme.of(context).darkBG,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: EnduranceTheme.of(context).primaryColor,
                  barrierColor: Color(0x230E151B),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 1,
                        child: CreateTaskNewWidget(),
                      ),
                    );
                  },
                ).then((value) => setState(() {}));
              },
              backgroundColor: EnduranceTheme.of(context).primaryColor,
              elevation: 8,
              child: Icon(
                Icons.add_rounded,
                color: EnduranceTheme.of(context).primaryWhite,
                size: 28,
              ),
            ),
            body: Builder(builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: EnduranceTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.asset(
                              'assets/page__bg.jpg',
                            ).image,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'My Goals',
                                    textAlign: TextAlign.center,
                                    style: EnduranceTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 24,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              child: Text('Update'),
                              onPressed: () {
                                /*
                                final docUser = FirebaseFirestore.instance
                                    .collection('appTasks')
                                    .doc('dD0QeV2ayU34DvL784TW');

                                //update specific fields
                                docUser.update({
                                  //'name': 'EmmaABCE', //to update
                                  'Description': "hello1121",
                                  //'name': FieldValue.delete(), //to delete the field for the record
                                });
                                */
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyTasksWidget()));
                              },
                            ),
                            Container(
                              height: 10,
                              width: 300,
                              color: Colors.green,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text('TESTING'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    //child: FutureBuilder<List<AppTask>>( //StreamBuilder
                    child: StreamBuilder<List<AppTask>>(
                      //future: readAppTasks().first,
                      stream: readAppTasks(), //.first,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong! ${snapshot.error}',
                              style: TextStyle(color: Colors.white));
                        } else if (snapshot.hasData) {
                          final tasks = snapshot.data!;

                          return ListView(
                            //children: tasks.map(buildAppTask).toList(),
                            children: tasks.map(buildAppTask_check).toList(),
                          );
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green)));
                        }
                      },
                    ),
                  ),
                ],
              );
            })));
  }
}

Widget buildAppTask(AppTask t) => ListTile(
      leading: CircleAvatar(child: Text('o')),
      title: Text(t.taskName),
      //subtitle: Text(t.taskDescription),
      subtitle: Text(getDateTimeForAppTaskWidget(
          t.taskDate)), //(t.taskDate.toIso8601String()),
      /*
      Checkbox(
      checkColor: Colors.white,
      shape: CircleBorder(),
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        }),
    */
    );

Widget buildAppTask_check(AppTask t) => CheckboxListTile(
      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 12),
      title: Text(t.taskName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white)), //
      subtitle: Text(
          t.taskDescription +
              "\n\n" +
              getDateTimeForAppTaskWidget(t.taskDate) +
              "\n" +
              t.id +
              t.taskState.toString(),
          style: const TextStyle(color: Color(0xFFE0E3E7))),
      //value: t.taskState, //true, //false, //t.taskState,
      onChanged: (bool? value) {
        /*
        final docUser =
            FirebaseFirestore.instance.collection('appTasks').doc(t.id);

        bool bValue = t.taskState;

        //update specific fields
        docUser.update({
          'State': 'true', //!bValue, //to update
          //'hello': FieldValue.delete(), //to delete the field for the record
        });
        */
        updateAppTask(t);

        /*
        BuildContext context;

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyTasksWidget()));
        */
      },
      value: t.taskState, //true, //t.taskState,
      side: BorderSide(width: 2.0, color: Colors.green),
      secondary: const Icon(Icons.edit, color: Color(0xFFE0E3E7)),
      checkboxShape: CircleBorder(),
      checkColor: Colors.white,
      activeColor: Colors.green,
      tileColor: Color(0xFF171717),
    );

Future updateAppTask(AppTask t) async {
  final docUser = FirebaseFirestore.instance
      .collection('appTasks')
      //.doc('rjNIpUpm0BVbRnbbiSCQ');
      .doc(t.id);

  //debugPrint(t.id);
  bool newState = !t.taskState;

  await docUser.update({
    'State': newState, //!bValue, //to update
    //'hello': FieldValue.delete(), //to delete the field for the record
  });
}

String getDateTimeForAppTaskWidget(DateTime dt) {
  //dt format: "2022-10-09T16:05:00.0000"
  String s = "";
  String sDT = dt.toIso8601String();

  String sYear = sDT.substring(0, 4);
  String sMonth = sDT.substring(5, 7);
  String sDay = sDT.substring(8, 10);
  String sTime = sDT.substring(11, 16);

  int month = int.parse(sMonth);

  switch (month) {
    case 1:
      sMonth = "Jan";
      break;
    case 2:
      sMonth = "Feb";
      break;
    case 3:
      sMonth = "Mar";
      break;
    case 4:
      sMonth = "Apr";
      break;
    case 5:
      sMonth = "May";
      break;
    case 6:
      sMonth = "June";
      break;
    case 7:
      sMonth = "July";
      break;
    case 8:
      sMonth = "Aug";
      break;
    case 9:
      sMonth = "Sep";
      break;
    case 10:
      sMonth = "Oct";
      break;
    case 11:
      sMonth = "Nov";
      break;
    case 12:
      sMonth = "Dec";
      break;
  }

  s = sDay + " " + sMonth + " at " + sTime;

  if (sYear != "2022") {
    s += " (" + sYear + ")";
  }

  return s;
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.lightGreen;
  }
  return Colors.green;
}

//////////////////////////////////////////////////
