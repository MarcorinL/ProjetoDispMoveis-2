import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
        backgroundColor: Colors.deepPurple,
        
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 100, 50, 100),
        color: Colors.deepPurple.shade50,
        child: ListView(
          children: [
            ClipRect(
              clipBehavior: Clip.hardEdge,
              child: new Image.asset('./lib/images/logo1.png', width: 200),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: txtEmail,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple.shade700)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                        ),
                        fillColor: Colors.deepPurple.shade100,
                        filled: true,
                        hintStyle: TextStyle( fontSize: 14, color: Colors.deepPurple.shade300),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    TextField(
                      obscureText: true,
                      controller: txtSenha,
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple.shade700)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                        ),
                        fillColor: Colors.deepPurple.shade100,
                        filled: true,
                        hintStyle: TextStyle( fontSize: 14, color: Colors.deepPurple.shade300),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                        ),
                        child: const Text('Entrar'),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          login(txtEmail.text, txtSenha.text);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 150,
                      child: TextButton(
                        child: const Text('Criar conta', style: TextStyle(color: Colors.deepPurple),),
                        onPressed: () {
                        Navigator.pushNamed(context, '/criar_conta');
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),],
        ),
      ),
    );
  }

//LOGIN com Firebase Auth
void login(email,senha){
  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha).then((value) {
    Navigator.pushNamed(context, '/home');
  }).catchError((erro){
      var mensagem = '';
      if (erro.code == 'user-not-found'){
        mensagem = 'ERRO: Usuário não encontrado';
      }else if (erro.code == 'wrong-password'){
        mensagem = 'ERRO: Senha incorreta';
      }else if ( erro.code == 'invalid-email'){
        mensagem = 'ERRO: Email inválido';
      }else{
        mensagem = erro.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagem),
            duration: const Duration(seconds:2)
          )
      );
  });
}

}