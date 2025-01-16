import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:blockchain_example/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class NotesServices extends ChangeNotifier {
  List<Note> notes =[];
   final String _rpcUrl = "http://127.0.0.1:7545";
   final String _wsUrl = "ws://127.0.0.1:7545";
   bool isLoading =true;
   final String _privateKey = "0xad3cb0519fa292db74d2727ceac0215b9e597f5c1eb48f3456b195d94e6492cb";


   late Web3Client _web3client;
   late ContractAbi _contractAbi;
   late EthereumAddress _contractAddress;

   NotesServices (){
    initMethod();
    getABI ();
    // getCredentials();
    // getDeployedContract ();
    // fetchNotes();
   }
   
     Future<void> initMethod() async {

      _web3client  = Web3Client(_rpcUrl, http.Client(),socketConnector: (){
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
     }

     Future<void> getABI () async{

      try{
      String abiFile = await rootBundle.loadString('build/contracts/NotesContract.json');

      print(abiFile);

      var jsonABI = jsonDecode(abiFile);

      _contractAbi = ContractAbi.fromJson(jsonEncode(jsonABI['abi']),"note");

      _contractAddress =  EthereumAddress.fromHex(jsonABI['networks']['5777']['address']);


      _cred = EthPrivateKey.fromHex(_privateKey);


     _deployedContract = DeployedContract(_contractAbi, _contractAddress);
     _createNote = _deployedContract.function('createNote');
     _deleteNote = _deployedContract.function('deleteNote');
     _notes = _deployedContract.function('notes');
     _notesCount = _deployedContract.function('noteCount');

     fetchNotes();

      }catch(e){
       print(e.toString());
      }


}

Future<void> transaction() async {
 
  EthereumAddress ownAddress = _cred.address;

  EthereumAddress reciever = EthereumAddress.fromHex("0x172b6B45ec23f1151597b523E48114c6570Adea6");

  _web3client.sendTransaction(_cred, Transaction(from: ownAddress,to: reciever,value: EtherAmount.fromInt(EtherUnit.ether, 20)),fetchChainIdFromNetworkId: false,chainId: 1337,);


 
}

late EthPrivateKey _cred;

Future<void> getCredentials() async {
   _cred = EthPrivateKey.fromHex(_privateKey);
}

late DeployedContract _deployedContract;
late ContractFunction _createNote;
late ContractFunction _deleteNote;
late ContractFunction _notes;
late ContractFunction _notesCount;


Future<void> getDeployedContract () async {

  _deployedContract = DeployedContract(_contractAbi, _contractAddress);
  _createNote = _deployedContract.function('createNote');
  _deleteNote = _deployedContract.function('deleteNote');
  _notes = _deployedContract.function('notes');
  _notesCount = _deployedContract.function('noteCount');


}

Future<void> fetchNotes() async {
  List totalTaskList = await _web3client.call(contract: _deployedContract, function: _notesCount, params: []);

  int totalTaskLen = totalTaskList[0].toInt();

  notes.clear();

  for(int i =0;i<totalTaskLen;i++){
    var tmp= await _web3client.call(contract: _deployedContract, function: _notes, params: [BigInt.from(i)]);
    if(tmp[1]!=""){
      notes.add(Note(id: (tmp[0] as BigInt).toInt(), title: tmp[1], description: tmp[2]));
    }
  }
  isLoading =false;
  notifyListeners();
}

Future<void> addNotes({required String title,required String description}) async{

try{
  await _web3client.sendTransaction(_cred, Transaction.callContract(contract: _deployedContract, function: _createNote, parameters: [title,description],),fetchChainIdFromNetworkId: false,chainId: 1337,);
  isLoading =true;
  notifyListeners();
  fetchNotes();
}catch(e){
  print(e.toString());
}
}

Future<void> deleteNote({required int id,}) async{

try{
  await _web3client.sendTransaction(_cred, Transaction.callContract(contract: _deployedContract, function: _deleteNote, parameters: [BigInt.from(id)],),fetchChainIdFromNetworkId: false,chainId: 1337,);
  isLoading =true;
  notifyListeners();
  fetchNotes();
}catch(e){
  print(e.toString());
}
}
 
  
}