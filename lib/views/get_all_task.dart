import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/models/task_list.dart';
import 'package:zia_ali_project_api/services/task.dart';
import 'package:zia_ali_project_api/views/create_task.dart';
import 'package:zia_ali_project_api/views/filter_task.dart';
import 'package:zia_ali_project_api/views/get_completed_task.dart';
import 'package:zia_ali_project_api/views/get_in_completed_task.dart';
import 'package:zia_ali_project_api/views/search_task.dart';
import 'package:zia_ali_project_api/views/update_task.dart';

import '../providers/token.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
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
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchTaskView()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FilterTaskView()));
              },
              icon: Icon(Icons.date_range)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTaskView()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureProvider.value(
        value: TaskServices().getAllTasks(tokenProvider.getToken.toString()),
        initialData: TaskListModel(),
        builder: (context, child) {
          TaskListModel taskListModel = context.watch<TaskListModel>();
          return taskListModel.tasks == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: taskListModel.tasks!.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.task),
                      title:
                          Text(taskListModel.tasks![i].description.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateTaskView(
                                            model: taskListModel.tasks![i])));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                try {
                                  await TaskServices()
                                      .deleteTask(
                                          token:
                                              tokenProvider.getToken.toString(),
                                          taskID: taskListModel.tasks![i].id
                                              .toString())
                                      .then((val) {
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Task has been deleted successfully')));
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    );
                  });
        },
      ),
    );
  }
}
