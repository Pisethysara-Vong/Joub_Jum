import 'package:flutter/material.dart';

class InvitationsAndJoubJumsState with ChangeNotifier {
  final List<Map<String, dynamic>> _invitations = [
    {
      "creator": "Panha",
      "user": "Kati",
      "date": "03/11/24",
      "time": "6:00 PM",
      "location": "Ambience Bar",
      "imagePath": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
      "placeId": "ChIJT17FJIlRCTERKJ2gjPwJf6A",
      "invitees": [
        {
          "name": "Kati",
          "image": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> _joubJums = [];

  List<Map<String, dynamic>> get invitations => _invitations;

  List<Map<String, dynamic>> get joubJums => _joubJums;

  void acceptInvitation(Map<String, dynamic> invitation) {
    _invitations.remove(invitation);

    Map<String, dynamic>? existingJoubJum;

    for (var joubJum in _joubJums) {
      if (joubJum['creator'] == invitation['creator']) {
        existingJoubJum = joubJum;
        break;
      }
    }

    if (existingJoubJum != null) {
      existingJoubJum['going'] ??= <Map<String, String>>[];
      existingJoubJum['going'].add({
        'name': invitation['user'].toString(),
        'image': invitation['imagePath'].toString(),
      });
    } else {
      final newJoubJum = {...invitation};
      newJoubJum['going'] = [
        {
          'name': invitation['creator'].toString(),
          'image': invitation['imagePath'].toString(),
        },
        {
          'name': invitation['user'].toString(),
          'image': invitation['imagePath'].toString(),
        }
      ];
      _joubJums.add(newJoubJum);
    }

    notifyListeners();
  }

  void rejectInvitation(Map<String, dynamic> invitation) {
    _invitations.remove(invitation);
    notifyListeners();
  }

  void createJoubJum(Map<String, dynamic> joubjum){
    _joubJums.add(joubjum);
    _invitations.add(joubjum);
    notifyListeners();
  }

  void deleteJoubJum(Map<String, dynamic> joubjum){
    _joubJums.remove(joubjum);
    notifyListeners();
  }
}