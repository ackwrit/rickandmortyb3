import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rickandmorty_b3/detail_perso.dart';

import 'package:rickandmorty_b3/model/personnage.dart';
import 'package:rickandmorty_b3/model/resultat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List <Resultat> listePersonnage=[];
  late var jsonResponse;
  String apiAdresse = "https://rickandmortyapi.com/api/character";


  Future init(String adresseUrl) async {
    Uri url = Uri.parse(adresseUrl);
    Response responseAdresse = await http.get(url);
    jsonResponse = convert.jsonDecode(responseAdresse.body) as Map<String,dynamic>;
    int index=0;
    print('avant boucle');
    while (index<jsonResponse["results"].length)
      {
        setState(() {
          Resultat resultat = Resultat.json(jsonResponse["results"][index] as Map<String,dynamic>);
          listePersonnage.add(resultat);
        });
        index++;

      }
    print('après boucle');
      if(jsonResponse['info']['next']!=null){
        init(jsonResponse['info']['next']);
      }







  }






  @override void initState() {
    // TODO: implement initState
    print('avant fonction');
    init(apiAdresse);
    print('après fonction');
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print(listePersonnage[0].name);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: bodyPage(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget bodyPage(){

    return GridView.builder(
      itemCount: listePersonnage.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context,int index){
        return InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(listePersonnage[index].image),
                    fit: BoxFit.fill
                )
            ),



          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return detailPerso(perso: listePersonnage[index]);
                }
            ));
          },
        );

        }
    );
  }
}
