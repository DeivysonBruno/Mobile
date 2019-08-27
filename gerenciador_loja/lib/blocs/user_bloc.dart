
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase{

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map <String, Map<String, dynamic>> _users = Map();

  Firestore _firestore = Firestore.instance;

  UserBloc(){
    addUsersListener();
  }

  void addUsersListener(){
    _firestore.collection("user").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
        String uid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _users[uid]= change.document.data;
            subscribToOrders(uid);

            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());

            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribe(uid);
            _usersController.add(_users.values.toList());
            break;
        }

      });
    });
  }

  void subscribToOrders(String uid) async {
    _users[uid]['subscription'] = _firestore.collection("user").document(uid).collection('orders').snapshots().listen((orders)async {
      int numOrders = orders.documents.length;
      double money = 0.0;

      for(DocumentSnapshot d in orders.documents){
      DocumentSnapshot order= await  _firestore.collection("orders").document(d.documentID).get();
      if(order.data == null) continue;

      money += order.data['total'];
      }
      _users[uid].addAll(
        {
        'money': money, 'orders': numOrders
        }

      );
      _usersController.add(_users.values.toList());

    });

  }
  void onChangedSearch(String search){
    if(search.trim().isEmpty ){
      _usersController.add(_users.values.toList());
    }else{
      _usersController.add(_filter(search.trim()));

      
    }
    
  }
  Map<String, dynamic> getUser(String uid){
    return _users[uid];
  }

 List <Map<String, dynamic>> _filter(String search){
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());
    filteredUsers.retainWhere((user){
      return user['name'].toUpperCase().contains(search.toUpperCase());
    });

    return filteredUsers;



  }

  void _unsubscribe(String uid){
    _users[uid]['subscription'].cancel();
  }

  @override
  void dispose() {

    _usersController.close();
    // TODO: implement dispose
  }

}