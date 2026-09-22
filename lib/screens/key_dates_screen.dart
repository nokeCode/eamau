import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widgets/common/app_bar.dart';
import '../models/date/key_date_model.dart';
import '../services/date/key_date_service.dart';

class KeyDatesScreen extends StatefulWidget {
  const KeyDatesScreen({super.key});

  @override
  State<KeyDatesScreen> createState() => _KeyDatesScreenState();
}

class _KeyDatesScreenState extends State<KeyDatesScreen> {
  final KeyDateService _dateService = KeyDateService();
  List<KeyDateModel> _dates = [];
  bool _isLoading = true;
  String _selectedCategory = 'Toutes';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR');
    _loadKeyDates();
  }

  Future<void> _loadKeyDates() async {
    try {
      final dates = await _dateService.getKeyDates();
      if (mounted) {
        setState(() {
          _dates = dates.isNotEmpty ? dates : _dateService.getFallbackKeyDates();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _dates = _dateService.getFallbackKeyDates();
          _isLoading = false;
        });
      }
    }
  }

  List<KeyDateModel> _getFilteredDates() {
    if (_selectedCategory == 'Toutes') {
      return _dates;
    }
    return _dates.where((date) => date.category == _selectedCategory).toList();
  }

  List<String> _getCategories() {
    final categories = _dates
        .map((date) => date.category ?? 'Autres')
        .toSet()
        .toList()
      ..sort();
    categories.insert(0, 'Toutes');
    return categories;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final difference = dateOnly.difference(today).inDays;
    
    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Demain';
    } else if (difference > 1 && difference <= 7) {
      return 'Dans ${difference} jours';
    } else if (difference < 0) {
      return '${DateFormat('dd MMM yyyy', 'fr').format(date)} (Passé)';
    }
    
    return DateFormat('dd MMM yyyy', 'fr').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final filteredDates = _getFilteredDates();
    final categories = _getCategories();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Dates Clés'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFFF1F7FF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Calendrier académique',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D4B9C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Échéances et événements importants',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF0D4B9C),
                                  fontSize: 14,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              selectedColor: const Color(0xFF0D4B9C),
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: isSelected 
                                    ? const Color(0xFF0D4B9C) 
                                    : Colors.grey[300]!,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: filteredDates.isEmpty
                        ? Center(
                            child: Text(
                              'Aucune date disponible pour cette catégorie',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredDates.length,
                            itemBuilder: (context, index) {
                              final date = filteredDates[index];
                              final dateText = _formatDate(date.date);
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: date.isImportant 
                                                  ? const Color(0xFFFFE5E5) 
                                                  : const Color(0xFFE5F2FF),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              date.isImportant ? 'IMPORTANT' : date.category ?? 'Événement',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: date.isImportant 
                                                    ? const Color(0xFFDC2626) 
                                                    : const Color(0xFF1682F8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            dateText,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        date.title,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0D4B9C),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      if (date.description != null && date.description!.isNotEmpty)
                                        Text(
                                          date.description!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            height: 1.4,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),

    );
  }
}
