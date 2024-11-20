import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernamedController = TextEditingController();


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
                  Text("Register",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w700,color: Colors.black),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You have already an account?",style: 
                      TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF6C7278))),
                    Text("Login",style: 
                      TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xFF0A1EBE))),
                    ],
                  ),
                  SizedBox(height: 20,),
                   Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username"),
                      Container(
                        width: 295,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Color(0xFFEDF1F3))
                        ),
                        child: TextFormField(
                          controller: usernamedController,
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
                
                GestureDetector(
                  onTap: (){
                   
                  },
                  child: Container(
                    height: 48,width: 295,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),)),
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