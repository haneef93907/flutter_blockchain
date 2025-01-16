import 'package:blockchain_example/add_notes.dart';
import 'package:blockchain_example/notes_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => NotesServices(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var noteService = context.watch<NotesServices>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Notes Contract"),
      ),
      body: Center(
        child: noteService.notes.isEmpty ? Text("No Notes Found"): noteService.isLoading ? CircularProgressIndicator(color: Colors.blue,):Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: ListView.separated(
            separatorBuilder: (context,index){
              return SizedBox(height: 10,);
            },
            itemCount: noteService.notes.length,
            itemBuilder: (context,index){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${noteService.notes[index].title}",style: TextStyle(fontSize: 18),),
                      Text("${noteService.notes[index].description}",style: TextStyle(fontSize: 14,color: Colors.grey),),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){
                         noteService.transaction();
                      }, icon: Icon(Icons.money,color: Colors.blue,)),
                      IconButton(onPressed: (){
                          noteService.deleteNote(id:noteService.notes[index].id);
                      }, icon: Icon(Icons.delete,color: Colors.red,)),
                    ],
                  )
                ],
              );
          
            }),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context){
          return AddNotes();
         }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
