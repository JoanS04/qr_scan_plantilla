import 'package:flutter/material.dart';

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