import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1_marcorin/pages/inserir_vagas.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'pages/login.dart';
import 'pages/criar_conta.dart';
import 'pages/inserir_vagas.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navegação',

      //Rotas de navegação
      initialRoute: '/login',
      routes: {
        '/login': (context) => TelaLogin(),
        '/criar_conta': (context) => TelaCriarConta(),
        '/home': (context) => TelaHome(),
        '/inserir': (context) => TelaInserirVaga(),
        'tHabilidades': (context) => TelaHabilidades(),
        'tVagas': (context) => TelaVagas(),
        'tTarefas': (context) => TelaTarefas(),
        'tSobre': (context) => TelaSobre(),
      },
    ),
  );
}

//Tela Home
class TelaHome extends StatefulWidget {
  const TelaHome({ Key? key }) : super(key: key);

  @override
  _TelaHomeState createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  
  int selectedIndex=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        padding: EdgeInsets.fromLTRB(50, 30, 50, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                //Text(user, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent.shade700,)),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed:() {
                    Navigator.pushNamed(context, 'tHabilidades');
                  },
                  icon: Icon(Icons.star_border, size: 100,),
                  label: Text('Habilidades'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 120),
                    primary: Colors.deepPurple,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed:(){
                    Navigator.pushNamed(context, 'tTarefas');
                  },
                  icon: Icon(Icons.checklist_rtl, size: 100),
                  label: Text('Tarefas'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    fixedSize: Size(250, 120),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pushNamed(context, 'tVagas');
                  },
                  icon: Icon(Icons.bar_chart, size: 100),
                  label: Text('Vagas'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    fixedSize: Size(250, 120),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),],
            ),],
        ),
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple,
        iconSize: 30,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple.shade300,
        currentIndex: selectedIndex,
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
            Navigator.pushNamed(context, 'tLogin');
          }
          },);
        }
      ),
    );
  }
}


//Tela Vagas
class TelaVagas extends StatefulWidget {
  const TelaVagas({ Key? key }) : super(key: key);

  @override
  _TelaVagasState createState() => _TelaVagasState();
}

class _TelaVagasState extends State<TelaVagas> {

//Referenciar a coleção de vagas
late CollectionReference vagas;

@override
void initState(){
  super.initState();
  vagas = FirebaseFirestore.instance.collection('vagas');
}

//método para o perfil dos cards
Widget itemLista(item){
  String empresa = item.data()['empresa'];
  String cargo = item.data()['cargo'];
  String data = item.data()['data'];

  return ListTile(
    title: Text(empresa, style: const TextStyle(color: Colors.deepPurple)),
    subtitle: Text('$cargo, $data', style: TextStyle(color: Colors.deepPurple)),
    trailing: IconButton(
      icon: Icon(Icons.delete, color: Colors.deepPurple),
      onPressed: (){
        vagas.doc(item.id).delete();
      }
    ),

    ////////////
    //Tem alguma coisa estranah acontecendo com esse trecho...
    //onTap: (){
      //Navigator.pushNamed(context, '/inserir', arguments: item.id);
    //},
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Acompanhe suas candidaturas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: vagas.snapshots(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Center(child:Text('Não foi possível acessar o banco de dados.'));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              final dados = snapshot.requireData;
              return ListView.builder(
                itemCount: dados.size,
                itemBuilder: (context, index){
                  return itemLista(dados.docs[index]);
                },
              );
          }
        },
      ),
      
      //Adicionar vagas
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/inserir');
        },
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurpleAccent.shade700,
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

//Tela Tarefas
class TelaTarefas extends StatefulWidget {
  const TelaTarefas({ Key? key }) : super(key: key);

  @override
  _TelaTarefasState createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {

List<bool> _isOpen=List.filled(8, false);

bool linkedinOpen=false;
bool linkedinVagas=false;
bool linkedinEmpresas=false;
bool linkedinProf=false;
bool linkedinGroups=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.deepPurpleAccent.shade700
      ),
      body: SingleChildScrollView(
        child:Container(
            padding: EdgeInsets.all(50),
            color: Colors.deepPurple.shade50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), 
                      )
                    ]
                  ),
                  child: Column(children:[
                    Text('Sabemos que a trasição da área acadêmica para a privada não é fácil.\nPor isso listamos alguns passos para te guiar.\n\nAqui estão algumas das iniciativas que você deve tomar para encontrar vagas e se candidatar à elas com mais agilidade.\nNo começo pode parecer muita coisa, mas com o tempo essas atividades vão fazer parte da sua rotina.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),),
                  ]),
                ),
                SizedBox(height: 20,),
                ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.fromLTRB(2, 10, 2, 10),
                  children: [
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Definir o segmento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 1,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Saber em qual segmento trabalhar é importante!',textAlign: TextAlign.left , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Você precisa ter uma ideia de qual segmento do mercado você se encaixa e gostaria de trabalhar. Pesquise sobre as empresas que empregam os serviços que você pode ou quer oferecer e veja à que segmento elas pertencem.', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Adicione aqui os segmentos que te interessam (ex: agroindústria, tecnologia, recursos humanos):', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFieldTags(
                              textFieldStyler: TextFieldStyler(contentPadding: EdgeInsets.all(6), hintText: 'Adicione suas TAGs', hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), textFieldFocusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.shade300)), helperText: '', helperStyle: TextStyle(fontSize: 1)),
                              tagsStyler: TagsStyler(
                                tagTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700,),
                                tagDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                tagCancelIcon: Icon(Icons.cancel, size: 14, color: Colors.deepPurpleAccent.shade700),
                                tagPadding: EdgeInsets.all(6),
                              ),
                              onTag: (tag){print(tag);},
                              onDelete: (tag){
                                setState((){
                                      });
                              },
                            ),
                          ),
                        ],
                      ),
                      isExpanded: _isOpen[0],
                      canTapOnHeader: true,
                    ),
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Empresas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 2,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Conheça as empresas dentro dos seus segmentos!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('É importante conhecer as empresas dentro dos segmentos de mercado você se encaixa e gostaria de trabalhar. Você deve também acompanhar essas empresas em suas redes sociais, principalmente no LinkedIn, onde geralmente são postadas as vagas.', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Adicione aqui as empresas que te interessam (ex: google, ourofino, hospital sírio libanês):', style: TextStyle(color: Colors.white)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFieldTags(
                              textFieldStyler: TextFieldStyler(contentPadding: EdgeInsets.all(6), hintText: 'Adicione suas TAGs', hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), textFieldFocusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.shade300)), helperText: '', helperStyle: TextStyle(fontSize: 1)),
                              tagsStyler: TagsStyler(
                                tagTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700,),
                                tagDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                tagCancelIcon: Icon(Icons.cancel, size: 14, color: Colors.deepPurpleAccent.shade700),
                                tagPadding: EdgeInsets.all(6),
                              ),
                              onTag: (tag){print(tag);},
                              onDelete: (tag){
                                setState((){
                                      });
                              },
                            ),
                          ),
                        ],
                      ),
                      isExpanded: _isOpen[1],
                      canTapOnHeader: true,
                    ),
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Cargos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        
                        spacing: 2,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Defina os cargos que quer concorrer!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('É importante conhecer os cargos que você gostaria de ter dentro de uma empresa. Pesquise as vagas disposníveis nas empresas que você listou e estude os cargos', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Adicione aqui os cargos que te interessam (ex: analista de contas, gerente de produção, redator):', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFieldTags(
                              textFieldStyler: TextFieldStyler(contentPadding: EdgeInsets.all(6), hintText: 'Adicione suas TAGs', hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), textFieldFocusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.shade300)), helperText: '', helperStyle: TextStyle(fontSize: 1)),
                              tagsStyler: TagsStyler(
                                tagTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700,),
                                tagDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                tagCancelIcon: Icon(Icons.cancel, size: 14, color: Colors.deepPurpleAccent.shade700),
                                tagPadding: EdgeInsets.all(6),
                              ),
                              onTag: (tag){print(tag);},
                              onDelete: (tag){
                                setState((){
                                      });
                              },
                            ),
                          ),
                        ],
                      ),
                      isExpanded: _isOpen[2],
                      canTapOnHeader: true,
                    ),
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Competências', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        
                        spacing: 2,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Liste as competências e habilidades exigidas para os cargos que quer concorrer!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('É importante conhecer as competências e habilidades que as empresas esperam dos candidatos concorrendos aos cargos. Estude as vagas disposníveis nas empresas que você listou e liste as competências', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Adicione aqui as competências e habilidades comuns entre os cargos (ex: analista de contas, gerente de produção, redator):', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFieldTags(
                              textFieldStyler: TextFieldStyler(contentPadding: EdgeInsets.all(6), hintText: 'Adicione suas TAGs', hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), textFieldFocusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.shade300)), helperText: '', helperStyle: TextStyle(fontSize: 1)),
                              tagsStyler: TagsStyler(
                                tagTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700,),
                                tagDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                tagCancelIcon: Icon(Icons.cancel, size: 14, color: Colors.deepPurpleAccent.shade700),
                                tagPadding: EdgeInsets.all(6),
                              ),
                              onTag: (tag){print(tag);},
                              onDelete: (tag){
                                setState((){
                                      });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child:Row(
                              children: [
                                Expanded(
                                  child: Text('Já avaliou as suas competências e habilidades na página de habilidades do app?', style: TextStyle(color: Colors.white), maxLines:2, overflow: TextOverflow.ellipsis, softWrap: true,),
                                  ),
                                Checkbox(
                                  checkColor: Colors.greenAccent.shade700,
                                  activeColor: Colors.deepPurple.shade50,
                                  focusColor: Colors.deepPurple.shade50,
                                  value: linkedinGroups,
                                  onChanged: (bool? value) {
                                    setState((){
                                      linkedinGroups = value!;
                                    });
                                  },
                                ),
                              ],
                            ),)
                          )
                        ],
                      ),
                      isExpanded: _isOpen[3],
                      canTapOnHeader: true,
                    ),
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Currículos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 2,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Construa currículos específicos para cada vaga!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Cada vaga irá exigir competências e habilidades diferentes dos candidatos, por isso não faz sentido usar o mesmo currículo para todas elas. Construa currículos de acordo com o tipo de vaga que está concorrendo.', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Adicione aqui os tipos de currículo que você deve criar (ex: analista, gerente, professor etc):', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFieldTags(
                              textFieldStyler: TextFieldStyler(contentPadding: EdgeInsets.all(6), hintText: 'Adicione suas TAGs', hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), textFieldFocusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.shade300)), helperText: '', helperStyle: TextStyle(fontSize: 1)),
                              tagsStyler: TagsStyler(
                                tagTextStyle: TextStyle(fontSize: 12, color: Colors.deepPurpleAccent.shade700,),
                                tagDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                tagCancelIcon: Icon(Icons.cancel, size: 14, color: Colors.deepPurpleAccent.shade700),
                                tagPadding: EdgeInsets.all(6),
                              ),
                              onTag: (tag){print(tag);},
                              onDelete: (tag){
                                setState((){
                                      });
                              },
                            ),
                          ),
                        ],
                      ),
                      isExpanded: _isOpen[4],
                      canTapOnHeader: true,
                    ),
                    ExpansionPanel(
                      backgroundColor: Colors.deepPurpleAccent.shade700,
                      headerBuilder: (BuildContext context, bool isExpanded){
                        return ListTile(
                          title: Text('Networking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                        );
                      },
                      body: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        
                        spacing: 2,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Crie uma rede de referências!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Conhecer e criar relacionamentos com pessoas do ramo que quer trabalharvai te ajudar a encontrar oportunidades e indicações.\nQuem não é visto, não é lembrado.', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('Para criar essa rede você precisa estar ativo nela. Use o LinkedIn para conhecer e interagir com os profissionais do seu ramo de interesse e participe de eventos da área.', style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Crie uma conta LinkedIn', style: TextStyle(color: Colors.white),),
                                      Checkbox(
                                        checkColor: Colors.greenAccent.shade700,
                                        activeColor: Colors.deepPurple.shade50,
                                        focusColor: Colors.deepPurple.shade50,
                                        value: linkedinOpen,
                                        onChanged: (bool? value) {
                                          setState((){
                                            linkedinOpen = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Siga empresas interessantes no LinkedIn', style: TextStyle(color: Colors.white),),
                                      Checkbox(
                                        checkColor: Colors.greenAccent.shade700,
                                        activeColor: Colors.deepPurple.shade50,
                                        focusColor: Colors.deepPurple.shade50,
                                        value: linkedinEmpresas,
                                        onChanged: (bool? value) {
                                          setState((){
                                            linkedinEmpresas = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Crie alertas de vagas no LinkedIn', style: TextStyle(color: Colors.white),),
                                      Checkbox(
                                        checkColor: Colors.greenAccent.shade700,
                                        activeColor: Colors.deepPurple.shade50,
                                        focusColor: Colors.deepPurple.shade50,
                                        value: linkedinVagas,
                                        onChanged: (bool? value) {
                                          setState((){
                                            linkedinVagas= value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Siga grupos interessantes no LinkedIn', style: TextStyle(color: Colors.white),),
                                      Checkbox(
                                        checkColor: Colors.greenAccent.shade700,
                                        activeColor: Colors.deepPurple.shade50,
                                        focusColor: Colors.deepPurple.shade50,
                                        value: linkedinGroups,
                                        onChanged: (bool? value) {
                                          setState((){
                                            linkedinGroups = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Siga profissionais da sua área no LinkedIn', style: TextStyle(color: Colors.white),),
                                      Checkbox(
                                        checkColor: Colors.greenAccent.shade700,
                                        activeColor: Colors.deepPurple.shade50,
                                        focusColor: Colors.deepPurple.shade50,
                                        value: linkedinProf,
                                        onChanged: (bool? value) {
                                          setState((){
                                            linkedinProf = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                      isExpanded: _isOpen[5],
                      canTapOnHeader: true,
                    ),
                  ],
                  expansionCallback: (i, isOpen){
                    setState((){
                      _isOpen[i]=!isOpen;
                    });
                  }, 
                ),
              ],
            ),
          ),
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurpleAccent.shade700,
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

//Tela Sobre
class TelaSobre extends StatefulWidget {
  const TelaSobre({ Key? key }) : super(key: key);

  @override
  _TelaSobreState createState() => _TelaSobreState();
}

class _TelaSobreState extends State<TelaSobre> {

  int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sobre'),
        backgroundColor: Colors.deepPurpleAccent.shade700,
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        color: Colors.deepPurple.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRect(
              child: new Image.asset('./lib/images/logo.png',),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text('O PhD move foi criado para auxiliar pesquisadores na trasição da academia para a iniciativa privada.\nA transição de carreira é particularmente complexa para acadêmicos, pois a formação e experiência oferecidas pela pós graduação raramente preparam esses profissionais para trabalhar no meio privado e corporativo, que é muito diferente do acadêmico.', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple.shade800),textAlign: TextAlign.justify,),
                    SizedBox(height: 15,),
                    Text('O aplicativo foi desenvolvido por uma PhD que passou pela transição e sabe como ela pode ser desafiadora.', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple.shade800),textAlign: TextAlign.justify,),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text('Letícia Marcorin é Química (FFCLRP/USP), PhD em Genética (FMRP/USP) e graduanda em Análise e Desenvolvimento de Sistemas na FATEC RP.', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple.shade800),textAlign: TextAlign.justify,),
                        ),
                        SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('./lib/images/author.jpg', width: 120),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        )
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurpleAccent.shade700,
        iconSize: 30,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple.shade300,
        currentIndex: selectedIndex,
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


//Tela Habilidades
class TelaHabilidades extends StatefulWidget {
  const TelaHabilidades({ Key? key }) : super(key: key);

  @override
  _TelaHabilidadesState createState() => _TelaHabilidadesState();
}

class _TelaHabilidadesState extends State<TelaHabilidades> {
  double wComunicationRate=0;
  double oComunicationRate=0;
  double teamWork=0;
  double tutoring=0;
  double projCoord=0;
  double peopleCoord=0;
  double creativity=0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Minhas Habilidades Transferíveis'),
        backgroundColor: Colors.deepPurpleAccent.shade700,
      ),
      body: SingleChildScrollView(
        child:Container(
            padding: EdgeInsets.all(50),
            color: Colors.deepPurple.shade50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), 
                      )
                    ]
                  ),
                  child: Column(children:[
                    Text('Habilidades transferíveis são aquelas que podemos aplicar em diferentes situações, independente da área de atuação.\n\nReconhecer quia dessas habilidades você já domina e quais precisam ser trabalhadas vai te ajudar a construir currículos que cumpram com os requisitos das vagas.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),),
                    SizedBox(height: 10,),
                    Text('Ajuste as habilidades abaixo de acordo com a sua experiência\nSe tiver dúvidas do que as habilidades representam, clique no ícode de informação que te daremos exemplos.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),),
                  ]),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Comunicação escrita', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você escreve bem?\nConsegue se comunicar de forma clara e concisa nos seus textos?\nSabe apresentar um bom relatório?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: wComunicationRate,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: wComunicationRate.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      wComunicationRate=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Comunicação oral', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você se expressa bem?\nConsegue se comunicar de forma clara e concisa oralmente?\nSe sente confortável em apresentações orais?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: oComunicationRate,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: oComunicationRate.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      oComunicationRate=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Trabalho em equipe', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você se relaciona bem com as suas equipes de trabalho?\nConsegue trabalher de forma colaborativa?\nLida bem com críticas e sugestões ao seu trabalho?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: teamWork,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: teamWork.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      teamWork=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Ensinar e treinar', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você consegue ensinar e treinar pessoas?\nTem o costumo de compartilher os seus conhecimentos com colegas de trabalho?\nTem paciência para resolver dúvidas e problemas?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: tutoring,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: tutoring.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      tutoring=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Criatividade', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você pensa fora da caixa?\nTem ideias diferentes, inovadoras?\nCostuma resolver problemas de formas inusitadas?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: creativity,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: creativity.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      creativity=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Coordenação de projetos', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você tem experiência em propor, planejar e coordenar projetos?\nConsegue planejar as etapas e recursos necessários para realizar um projeto?\nSabe como avaliar o andamento e os resultados dos seus projetos?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: projCoord,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: projCoord.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      projCoord=novoValor;
                    });
                  },                  
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Coordenação de pessoas', style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 14, fontWeight: FontWeight.w600),)),
                    IconButton(
                      icon: Icon(Icons.info),
                      iconSize: 20,
                      color: Colors.deepPurple.shade700,
                      onPressed: ((){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Você tem experiência com a coordenação de grupos de trabalho?\nSabe reconhecer talentos e delegar tarefas?\nSabe como guiar e avaliar uma equipe?'),
                          duration: Duration(seconds: 8),
                          ));
                        });
                      }),
                    )
                  ],
                ),
                Slider(
                  value: peopleCoord,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  activeColor: Colors.deepPurpleAccent.shade700,
                  inactiveColor: Colors.deepPurpleAccent.shade400,
                  label: peopleCoord.round().toString(),
                  onChanged:(double novoValor){
                    setState(() {
                      peopleCoord=novoValor;
                    });
                  },                  
                ),
              ]
            )
        )
      ),
      //Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurpleAccent.shade700,
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