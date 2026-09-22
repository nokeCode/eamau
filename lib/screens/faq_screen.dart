import 'package:flutter/material.dart';

import '../widgets/common/app_bar.dart';
import '../models/faq/quiz_model.dart';
import '../services/faq/quiz_service.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final QuizService _quizService = QuizService();
  List<QuizModel> _faqs = [];
  bool _isLoading = true;
  List<int> _expandedIndices = [];

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  Future<void> _loadFAQs() async {
    try {
      final faqs = await _quizService.getFAQs();
      if (mounted) {
        setState(() {
          _faqs = [...faqs]..sort((a, b) => (a.position ?? 0).compareTo(b.position ?? 0));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'FAQ'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _faqs.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune FAQ disponible',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Foire aux questions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D4B9C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Trouvez rapidement les réponses à vos questions.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _faqs.length,
                          itemBuilder: (context, index) {
                            final faq = _faqs[index];
                            final isExpanded = _expandedIndices.contains(index);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  initiallyExpanded: isExpanded,
                                  onExpansionChanged: (expanded) {
                                    _toggleExpansion(index);
                                  },
                                  iconColor: const Color(0xFF1682F8),
                                  collapsedIconColor: const Color(0xFF1682F8),
                                  title: Text(
                                    faq.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D4B9C),
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ) + const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        faq.answer ?? 'Aucune réponse disponible',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      ),

    );
  }
}
