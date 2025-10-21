// test_data.dart
// Uses existing Hive-based TourDeck and Card classes (both extend HiveObject).
// Adjust the import paths below to match your project structure.

import 'dart:math';
import 'package:flutter/material.dart'
    hide Card; // Avoid clash with your Card model.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:tourdecks/models/tourdeck.dart';
import 'package:tourdecks/models/card.dart'; // Your Hive Card model (id, name, location, description, etc).
import 'package:tourdecks/data/services/image_storage_service.dart';

// Reuse your existing field names. If your constructors differ, adapt inside the loops.

String _buildDescription(String name, String city) {
  final baseSentences = <String>[
    '$name in $city stands as a defining landmark whose layered historical narratives, architectural presence, and continuing civic relevance have allowed it to remain emblematic of Japanese cultural continuity while also serving contemporary educational and reflective purposes for visitors and local communities alike.',
    'Its origins trace through periods of political reorganization, devotional transformation, and regional trade development, each era leaving structural, aesthetic, or ritual impressions that can still be inferred through stylistic motifs, spatial organization, and documentary references preserved in local archives and scholarly discourse.',
    'Architecturally, $name illustrates a disciplined negotiation between functional durability and symbolic articulation, where proportions, chosen materials, and crafted ornamental details communicate authority, sanctity, or memorial intention without surrendering to excess that would diminish structural clarity or long-term maintainability.',
    'Environmental siting in $city is neither accidental nor purely ornamental; natural contours, prevailing winds, seasonal light angles, and lines of civic approach were evaluated historically to choreograph a visitor’s perceptual sequence from distant silhouette recognition to intimate textural engagement at thresholds and interior precincts.',
    'The monument’s material palette reflects regionally available resources—timber species, stone varieties, metal alloys, and finishing lacquers—selected not only for endurance but also for their capacity to register time through weathering patterns, subtle color shifts, and tactile softening that collectively narrate cycles of care and renewal.',
    'Cultural significance of $name extends beyond static heritage designation; it functions as an interpretive platform where guided explanations, carefully curated signage, and scholarly publications intersect with local oral histories, seasonal ceremonies, and evolving community stewardship initiatives.',
    'Conservation methodologies applied in $city emphasize minimally invasive intervention, reversible reinforcement techniques, rigorous documentation protocols, and multidisciplinary consultation, aligning with international charters while honoring indigenous craftsmanship sensibilities and region-specific maintenance traditions.',
    'Visitor experience is intentionally stratified: casual observers apprehend iconic silhouettes and panoramic viewpoints, while more attentive guests discern joinery logic, proportional harmonies, craft tool marks, and layered spatial hierarchies that unveil pedagogical value in structural legibility.',
    'Symbolically, $name offers an adaptable canvas onto which successive generations project aspirations for resilience, aesthetic refinement, ethical remembrance, or communal cohesion, demonstrating how heritage sites remain dynamically negotiated cultural texts rather than inert relics.',
    'Educational programs coordinated in $city integrate primary source analysis, architectural drawing workshops, conservation science demonstrations, and reflective dialogues that frame the monument as a living laboratory for interdisciplinary inquiry across history, engineering, material science, and ethics.',
    'Risk management planning addresses seismic resilience, climatic volatility, biodeterioration vectors, and visitor impact through calibrated monitoring, sensor deployment, contingency drills, and incremental mitigation strategies designed to balance accessibility with stewardship obligations.',
    'The economic dimension is approached cautiously: heritage-driven tourism surrounding $name is leveraged to support artisanal apprenticeship pathways, research fellowships, and local infrastructure improvements, avoiding extractive commercialization that could erode authenticity or overwhelm carrying capacity.',
    'Interpretive narratives consciously contextualize $name within national and transnational networks of exchange, technological adaptation, and religious or civic reform, resisting oversimplified mythologizing by foregrounding complexity, contested memory layers, and documented historiographical debates.',
    'Seasonal phenomena—fluctuating humidity, snowfall, autumn foliage chromatics, and spring luminescence—modulate perceptual atmospheres around the monument, encouraging repeat visitation and longitudinal appreciation of cyclical environmental interplay with built form.',
    'Documentation leveraging high-resolution photogrammetry, structured light scanning, dendrochronological sampling, and archival digitization ensures future conservation planning can proceed with empirical baselines, transparent decision logs, and reproducible analytical pathways.',
    'Community engagement in $city incorporates volunteer maintenance days, oral history recording sessions, interpretive co-design workshops, and youth mentorship initiatives that embed stewardship ethics within local identity formation processes.',
    'Ethical interpretive framing acknowledges complexities such as prior site transformations, episodes of damage and reconstruction, and debates over authenticity criteria, inviting critical reflection on how preservation choices encode contemporary values into material interventions.',
    'The adaptive resilience of $name is evidenced by its capacity to accommodate evolving accessibility standards, discreet infrastructural upgrades, and interpretive technology integrations without compromising the legibility of original spatial intentions and artisanal integrity.',
    'A contemplative cadence permeates the site experience: carefully proportioned voids, transitional thresholds, framed vistas, acoustic dampening surfaces, and choreographed circulation loops induce a reflective temporal dilation that contrasts with accelerated urban rhythms elsewhere in $city.',
    'Ultimately, $name endures not by resisting change categorically but by absorbing, translating, and selectively curating influences—technical, environmental, pedagogical, and communal—into a coherent, intelligible, and dignified continuity that underscores the broader significance of heritage stewardship in contemporary society.',
  ];

  final chosen = <String>[...baseSentences];
  var text = chosen.join(' ');
  int wc() => text.trim().split(RegExp(r'\s+')).length;

  while (wc() < 480) {
    chosen.add(
      'In synthesizing historical depth, material intelligence, environmental responsiveness, and participatory governance, $name in $city illustrates how a monument can function simultaneously as archive, classroom, sanctuary, and civic catalyst while remaining materially truthful to its inherited fabric.',
    );
    text = chosen.join(' ');
  }
  final words = text.split(RegExp(r'\s+'));
  if (words.length > 520) {
    text = words.sublist(0, 515).join(' ');
  }
  return text;
}

final _monuments = [
  {'name': 'Kinkaku-ji', 'city': 'Kyoto'},
  {'name': 'Fushimi Inari Taisha', 'city': 'Kyoto'},
  {'name': 'Itsukushima Shrine', 'city': 'Hatsukaichi'},
  {'name': 'Himeji Castle', 'city': 'Himeji'},
  {'name': 'Senso-ji', 'city': 'Tokyo'},
  {'name': 'Osaka Castle', 'city': 'Osaka'},
  {'name': 'Todai-ji', 'city': 'Nara'},
  {'name': 'Tokyo Tower', 'city': 'Tokyo'},
  {'name': 'Mount Fuji', 'city': 'Fujinomiya'},
  {'name': 'Hiroshima Peace Memorial', 'city': 'Hiroshima'},
  {'name': 'Nikko Toshogu Shrine', 'city': 'Nikko'},
  {'name': 'Kiyomizu-dera', 'city': 'Kyoto'},
  {'name': 'Nagoya Castle', 'city': 'Nagoya'},
  {'name': 'Kumamoto Castle', 'city': 'Kumamoto'},
  {'name': 'Shuri Castle', 'city': 'Naha'},
  {'name': 'Matsumoto Castle', 'city': 'Matsumoto'},
  {'name': 'Nijo Castle', 'city': 'Kyoto'},
  {'name': 'Ginkaku-ji', 'city': 'Kyoto'},
  {'name': 'Kenroku-en Garden', 'city': 'Kanazawa'},
  {'name': 'Korakuen Garden', 'city': 'Okayama'},
];

void generateTestTourDecks(WidgetRef ref, {int seed = 42}) async {
  final rand = Random(seed);
  final pool = List<Map<String, String>>.from(_monuments);
  final decks = <TourDeck>[];
  final imageService = ref.read(imageStorageServiceProvider);

  // Pick 10 unique monuments for decks (or fewer if pool < 10).
  for (int i = 0; i < 10 && pool.isNotEmpty; i++) {
    final idx = rand.nextInt(pool.length);
    final deckMon = pool.removeAt(idx);
    final deckName = deckMon['name']!;
    final deckCity = deckMon['city']!;

    // Build 5 card monuments distinct from deck monument.
    final cardPool = List<Map<String, String>>.from(_monuments)
      ..removeWhere((m) => m['name'] == deckName);
    cardPool.shuffle(rand);
    final cardMonuments = cardPool.take(5).toList();

    final cardsIDs = <int>[];
    final cardBox = Hive.box<Card>('cards');
    for (var j = 0; j < cardMonuments.length; j++) {
      final c = cardMonuments[j];

      final imagePath = await imageService.getRandomTestImagePath();
      final key = await cardBox.add(
        Card(
          name: c['name']!,
          location: c['city']!,
          description: _buildDescription(c['name']!, c['city']!),
          imageURL: imagePath,
        ),
      );
      cardsIDs.add(key);
    }

    final deckBox = Hive.box<TourDeck>('decks');

    final deck = TourDeck(
      name: deckName,
      location: deckCity,
      cardIds: cardsIDs,
      isMine: true, // If your model uses HiveList<Card>, convert after box put.
    );

    deckBox.add(deck);
  }
}

// If your TourDeck.cards is a HiveList<Card>, after opening boxes:
// final cardBox = Hive.box<Card>('cards');
// final deckBox = Hive.box<TourDeck>('decks');
// for (final d in decks) {
//   for (final c in d.cards) { cardBox.put(c.id, c); }
//   d.cards = HiveList(cardBox, objects: d.cards);
//   deckBox.put(d.id, d);
// }
