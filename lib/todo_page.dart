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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Dbhelper dbHelper = widget.dbHelper!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
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
                                    Text(e.title),
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
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
          await dbHelper.insertNotes('Hello $_counter', 0);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
