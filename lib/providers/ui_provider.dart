import 'package:flutter/material.dart';


/*
Aquesta classe ens permetra controlar el menu inferior de la nostra app.
Per saber quina finestra hem de mostrar.
*/

class UIProvider extends ChangeNotifier{
  int _selectedOption = 1;

  int get selectedMenuOpt{
    return _selectedOption;
  }

  set selectedMenuOpt(int index){
    this._selectedOption = index;
    notifyListeners();
  }
}