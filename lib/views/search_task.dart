import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/models/task.dart';
import 'package:zia_ali_project_api/models/task_list.dart';
import 'package:zia_ali_project_api/services/task.dart';
import 'package:zia_ali_project_api/views/create_task.dart';
import 'package:zia_ali_project_api/views/get_completed_task.dart';
import 'package:zia_ali_project_api/views/get_in_completed_task.dart';

import '../providers/token.dart';

class SearchTaskView extends StatefulWidget {
  const SearchTaskView({super.key});

  @override
  State<SearchTaskView> createState() => _SearchTaskViewState();
}

class _SearchTaskViewState extends State<SearchTaskView> {
  TextEditingController searchController = TextEditingController();

  List<Task> taskList = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Task"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetCompletedTaskView()));
              },
              icon: Icon(Icons.circle)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetInCompletedTaskView()));
              },
              icon: Icon(Icons.incomplete_circle)),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onSubmitted: (val) async {
              try {
                isLoading = true;
                setState(() {});
                await TaskServices()
                    .searchTask(
                        token: tokenProvider.getToken.toString(),
                        searchKey: val)
                    .then((val) {
                  isLoading = false;
                  setState(() {});
                  taskList = val.tasks!;
                  setState(() {});
                });
              } catch (e) {
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (taskList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.task),
                      title: Text(taskList[i].description.toString()),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
