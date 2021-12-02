//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaCriarConta extends StatefulWidget {
  const TelaCriarConta({Key? key}) : super(key: key);

  @override
  _TelaCriarContaState createState() => _TelaCriarContaState();
}

class _TelaCriarContaState extends State<TelaCriarConta> {
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Criar conta'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple),
      backgroundColor: Colors.deepPurple[50],
      body: Container(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            ClipRect(
              clipBehavior: Clip.hardEdge,
              child: new Image.asset('./lib/images/logo1.png', width: 200),
            ),
            SizedBox(height: 50),
            TextField(
              controller: txtNome,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.deepPurple,),
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: txtEmail,
              style: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w300),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.deepPurple,), labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: txtSenha,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.deepPurple,),
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    child: const Text('Criar'),
                    onPressed: () {
                      criarConta(txtNome.text, txtEmail.text, txtSenha.text);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  //
  // CRIAR CONTA no Firebase Auth
  //
  void criarConta(nome, email, senha) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: senha,
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário criado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }).catchError((erro) {
      if (erro.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ERRO: O email informado já está em uso.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERRO: ${erro.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}