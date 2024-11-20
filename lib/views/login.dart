import 'package:flutter/material.dart';
import 'package:sher_mech/views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _validateAndLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      String errorMessage = "Please fill in all fields.";
      if (email.isEmpty && password.isNotEmpty) {
        errorMessage = "Email field cannot be empty.";
      } else if (password.isEmpty && email.isNotEmpty) {
        errorMessage = "Password field cannot be empty.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Color(0xFF0A1EBE),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFFFFF),
        child: Center(
          child: Container(
            width: 359,height: 468,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              
            ),
            child: Card(elevation: 2,
              color: Colors.white,
              child: Column(
                children: [
                  Text("Login",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700,color: Colors.black),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an company?",style: 
                      TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF6C7278))),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                      },
                      child: Text("Create",style: 
                        TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF0A1EBE))),
                    ),
                    ],
                  ),
                  SizedBox(height: 20,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      Container(
                        width: 295,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Color(0xFFEDF1F3))
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
    border: InputBorder.none, // Removes the underline
  ),
                          obscureText: true,
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password"),
                      Container(
                        width: 295,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Color(0xFFEDF1F3))
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
    border: InputBorder.none, // Removes the underline
  ),
                          obscureText: true,
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(
                                  color: Color(0xFF6C7278),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          TextButton(onPressed: (){}, 
                          child: Text("forgot password",style:TextStyle(color: Color(0xFF4D81E7),fontSize: 12,fontWeight: FontWeight.w600) ,))
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    _validateAndLogin();
                  },
                  child: Container(
                    height: 48,width: 295,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text("Log In",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),)),
                  ),
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}