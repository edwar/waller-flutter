import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/card_model.dart';
import 'dart:convert';
import '../helpers/card_color.dart';

class CardListBloc {
  BehaviorSubject<List<CardResults>> _cardsCollection =
      BehaviorSubject<List<CardResults>>();

  List<CardResults> _cardResults;

  //Retrive data from Stream
  Stream<List<CardResults>> get cardList => _cardsCollection.stream;

  void initialData() async {
    var initialData = await rootBundle.loadString('data/initialData.json');
    var decodeJson = jsonDecode(initialData);

    _cardResults = CardModel.fromJson(decodeJson).results;

    for (var i = 0; i < _cardResults.length; i++) {
      _cardResults[i].cardColor = CardColor.baseColor[i];
    }
    _cardsCollection.sink.add(_cardResults);
  }

  CardListBloc() {
    initialData();
  }

  void addCardToList(CardResults newCard) {
    _cardResults.add(newCard);
    _cardsCollection.sink.add(_cardResults);
  }

  void dispose() {
    _cardsCollection.close();
  }
}

final cardListBloc = CardListBloc();
