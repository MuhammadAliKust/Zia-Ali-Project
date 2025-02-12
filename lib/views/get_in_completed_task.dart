import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/models/task_list.dart';
import 'package:zia_ali_project_api/services/task.dart';

import '../providers/token.dart';

class GetInCompletedTaskView extends StatelessWidget {
  const GetInCompletedTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Get In Completed Task"),
      ),
      body: FutureProvider.value(
        value: TaskServices().getInCompletedTasks(
          tokenProvider.getToken.toString(),
        ),
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
                    );
                  });
        },
      ),
    );
  }
}
