import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bottom navigation bar için seçili index'i yöneten provider
final selectedIndexProvider = StateProvider<int>((ref) => 0);

// Bottom navigation bar'ın sayfa isimlerini tutan provider
final pageNamesProvider = Provider<List<String>>((ref) => [
  'Ara',
  'Takvim', 
  'Mesajlar',
  'Profil',
]);
