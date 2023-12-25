import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class ProfileViewModel with ChangeNotifier{
  int static = 0; //
  int modifile = 0;

  void updatescreen(){
    notifyListeners();
  }

  void displaySpinner() {
    static = 1;
    notifyListeners();
  }

  void hideSpinner() {
    static = 0;
    notifyListeners();
  }

  void setModifiled() {
    if(modifile == 0)
    {
      modifile = 1;
      notifyListeners();
    }
  }

  Future <void> updateProfile() async{
    static = 1;
    notifyListeners();
    await UserRepository().updateProfile();
    static = 0;
    modifile = 0;
    notifyListeners();
  }
}