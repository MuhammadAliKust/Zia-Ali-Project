import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/providers/token.dart';
import 'package:zia_ali_project_api/services/task.dart';
import 'package:zia_ali_project_api/views/get_all_task.dart';

class CreateTaskView extends StatefulWidget {
  CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
      ),
      body: Column(
        children: [
          TextField(
            controller: descriptionController,
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Description cannot be empty")));
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await TaskServices()
                          .createTask(
                              token: tokenProvider.getToken.toString(),
                              description: descriptionController.text)
                          .then((val) {
                        isLoading = false;
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Message"),
                                content:
                                    Text("Task has been created successfully"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GetAllTaskView()))
;                                      }, child: Text("Okay"))
                                ],
                              );
                            });
                      });
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Create Task"))
        ],
      ),
    );
  }
}
