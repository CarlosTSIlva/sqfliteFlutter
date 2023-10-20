import 'package:flutter/material.dart';
import 'package:sql/db_helper.dart';

class TodoPage extends StatefulWidget {
  TodoPage({
    super.key,
    required this.title,
    Dbhelper? dbHelper,
  })
  // init dbHelpepr
  : dbHelper = dbHelper ?? Dbhelper();

  final String title;
  final Dbhelper? dbHelper;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final Dbhelper dbHelper = widget.dbHelper!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      dbHelper.insertNotes('Hello', 0);
                    });
                  },
                  child: const Text("adicionar"),
                ),
              ),
              FutureBuilder(
                future: dbHelper.selectNotes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!
                          .map(
                            (e) => Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${e.title} e id: ${e.id}"),
                                    Switch(
                                      value: e.done == 1 ? true : false,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            dbHelper.updateNotes(
                                              e.id,
                                              value ? 1 : 0,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          dbHelper.deleteNotes(e.id);
                                        });
                                      },
                                      child: const Text("delete"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
