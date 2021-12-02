import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaInserirVaga extends StatefulWidget {
  const TelaInserirVaga({Key? key}) : super(key: key);

  @override
  _TelaInserirVagaState createState() => _TelaInserirVagaState();
}

class _TelaInserirVagaState extends State<TelaInserirVaga> {
  var txtEmpresa = TextEditingController();
  var txtCargo = TextEditingController();
  var txtData = TextEditingController();

  //
  // RETORNAR UM DOCUMENTO a partir do ID
  //
  getDocumentById(id) async{
    
    await FirebaseFirestore.instance.collection('vagas')
      .doc(id).get().then((doc){
        txtEmpresa.text = doc.get('empresa');
        txtCargo.text = doc.get('cargo');
        txtData.text = doc.get('data');
      });

  }

  @override
  Widget build(BuildContext context) {

    //
    // RECUPERAR o ID da vaga
    //
    var id = ModalRoute.of(context)?.settings.arguments;

    if (id != null){
      if (txtEmpresa.text.isEmpty && txtCargo.text.isEmpty && txtData.text.isEmpty){
        getDocumentById(id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Insira uma candidatura'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Container(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: [
            TextField(
              controller: txtEmpresa,
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                labelText: 'Empresa',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: txtCargo,
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                labelText: 'Cargo',
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: txtData,
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                labelText: 'Data',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    child: Text('Salvar'),
                    onPressed: () {
                      if (id == null){
                        FirebaseFirestore.instance
                            .collection('vagas')
                            .add({'empresa': txtEmpresa.text, 'cargo': txtEmpresa.text, 'data': txtData.text});
                      }else{
                        FirebaseFirestore.instance
                            .collection('vagas')
                            .doc(id.toString()).set({'empresa': txtEmpresa.text, 'cargo': txtCargo.text, 'data': txtData.text});
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Operação realizada com sucesso!'),
                        duration: Duration(seconds: 2),
                      ));

                      Navigator.pop(context);
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
                      child: const Text('cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple,
        iconSize: 30,
        selectedItemColor: Colors.deepPurple.shade300,
        unselectedItemColor: Colors.deepPurple.shade300,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Sair')
        ],
        onTap: (index){
          setState((){
          if(index==0){
            Navigator.pushNamed(context, 'tSobre');
          }else if(index==2){
            Navigator.pushNamed(context, '/login');
          }else{
            Navigator.pushNamed(context, '/home');
          }
          },);
        }
      ),
    );
  }
}