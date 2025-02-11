import 'package:flutter/material.dart';
import 'package:zia_ali_project_api/services/auth.dart';
import 'package:zia_ali_project_api/views/login.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: emailController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: pwdController,
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Name cannot be empty")));
                  return;
                }
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email cannot be empty")));
                  return;
                }
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email cannot be empty")));
                  return;
                }
                try {
                  await AuthServices()
                      .registerUser(
                          name: nameController.text,
                          email: emailController.text,
                          password: pwdController.text)
                      .then((val) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Message"),
                            content: Text("Registered Successfully"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginView()));
                                  },
                                  child: Text("Okay"))
                            ],
                          );
                        });
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: Text("Login"))
        ],
      ),
    );
  }
}
