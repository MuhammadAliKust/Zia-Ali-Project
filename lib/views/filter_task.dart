import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/models/task.dart';
import 'package:zia_ali_project_api/models/task_list.dart';
import 'package:zia_ali_project_api/services/task.dart';
import 'package:zia_ali_project_api/views/create_task.dart';
import 'package:zia_ali_project_api/views/get_completed_task.dart';
import 'package:zia_ali_project_api/views/get_in_completed_task.dart';

import '../providers/token.dart';

class FilterTaskView extends StatefulWidget {
  const FilterTaskView({super.key});

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {
  TextEditingController searchController = TextEditingController();

  List<Task> taskList = [];

  bool isLoading = false;

  DateTime? firstDate;
  DateTime? secondDate;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Task"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now())
                      .then((val) {
                    firstDate = val;
                    setState(() {});
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    firstDate == null
                        ? "Select First Date"
                        : DateFormat.yMMMd().format(firstDate!),
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now())
                      .then((val) {
                    secondDate = val;
                    setState(() {});
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    secondDate == null
                        ? "Select Second Date"
                        : DateFormat.yMMMd().format(secondDate!),
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  isLoading = true;
                  setState(() {});
                  await TaskServices()
                      .filterTask(
                          token: tokenProvider.getToken.toString(),
                          startDate: firstDate.toString(),
                          endDate: secondDate.toString())
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
              child: Text("Filter Task")),
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
