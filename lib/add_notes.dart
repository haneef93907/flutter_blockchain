import 'package:blockchain_example/notes_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _addNotesState();
}

class _addNotesState extends State<AddNotes> {
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(controller: titleTextEditingController,),
              const SizedBox(height: 20,),
              TextField(controller: descriptionController,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          noteService.addNotes(title: titleTextEditingController.text, description: descriptionController.text);
          Navigator.pop(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}