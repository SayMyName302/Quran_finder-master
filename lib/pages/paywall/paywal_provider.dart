import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumScreenProvider extends ChangeNotifier {
  int tappedIndex = 1;

  void updateTappedIndex(int index) {
    tappedIndex = index;
    notifyListeners();
  }

  List<ContainerModel> containers = [
    ContainerModel(id: 1, isTapped: false),
    ContainerModel(id: 2, isTapped: false),
    ContainerModel(id: 3, isTapped: false),
  ];

  void toggleTappedState(int containerId) {
    for (var i = 0; i < containers.length; i++) {
      if (containers[i].id == containerId) {
        containers[i].isTapped = !containers[i].isTapped;
      } else {
        containers[i].isTapped = false;
      }
    }
    notifyListeners();
  }
}

class ContainerModel {
  final int id;
  late final bool isTapped;

  ContainerModel({required this.id, required this.isTapped});
}

class UserModel {
  final String name;
  final String rating;
  final String avatarUrl;
  final String description;

  UserModel({
    required this.name,
    required this.rating,
    required this.avatarUrl,
    required this.description,
  });
}
