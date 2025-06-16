import 'package:flutter/material.dart' hide Card;
import 'package:hive_ce/hive.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/models/card.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<TourDeck>(), AdapterSpec<Card>()])
class HiveAdapters {}
