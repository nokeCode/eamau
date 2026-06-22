import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NewsModel> news = [
      NewsModel(
        title: "Atelier internationale",
        description:
        "Des figures territoriales et des architectures manifeste. Une exploration des Métropoles d'Afrique de l'Ouest",
        image: "assets/images/actualite1.jpg",
        date: "07 avril 2026",
      ),
      NewsModel(
        title: "Concours d'entrée",
        description:
        "Concours d'entrée au titre de l'année académique 2026-2027 du 12 au 13 mai 2026",
        image: "assets/images/actualite2.jpg",
        date: "12 mai 2026",
      ),
      NewsModel(
        title: "Installation du Comité d'organisation",
        description:
        "Réunion d'installation du Comité d'Organisation du Cinquantenaire de l'école",
        image: "assets/images/actualite3.jpg",
        date: "27 février 2026",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF0066FF),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendrier",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "Actualité",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: "Mes Études",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                color: const Color(0xFF0D7BFF),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  24,
                ),
                child: Column(
                  children: [

                    Row(
                      children: [

                        Container(
                          width: 42,
                          height: 42,
                          color: Colors.white,
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Université\nd'excellence",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.notifications,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                          _category(
                            "Toutes",
                            true,
                          ),

                          _category(
                            "Université",
                            false,
                          ),

                          _category(
                            "Recherche",
                            false,
                          ),

                          _category(
                            "Étudiant",
                            false,
                          ),

                          _category(
                            "Evènement",
                            false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(25),
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/campus.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(.2),
                              Colors.black.withOpacity(.7),
                            ],
                          ),
                        ),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "À LA UNE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            const Spacer(),

                            const Text(
                              "Inauguration du\nnouveau Campus\ndes Sciences",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 32,
                                height: 1.1,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              "Un espace innovant dédié à la recherche, à l’apprentissage et à la collaboration.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [

                                const Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color:
                                      Colors.white70,
                                      size: 15,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "24 mai 2024",
                                      style: TextStyle(
                                        color: Colors
                                            .white70,
                                      ),
                                    ),
                                  ],
                                ),

                                ElevatedButton(
                                  onPressed: () {},
                                  style:
                                  ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                    const Color(
                                      0xFF004AAD,
                                    ),
                                  ),
                                  child: const Text(
                                    "Lire l'article",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Dernière Actualité",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Voir Tout",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ListView.builder(
                      itemCount: news.length,
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = news[index];

                        return Container(
                          margin:
                          const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding:
                          const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                                15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),

                          child: Row(
                            children: [

                              ClipRRect(
                                borderRadius:
                                BorderRadius
                                    .circular(12),
                                child: Image.asset(
                                  item.image,
                                  width: 95,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [

                                    Text(
                                      item.title,
                                      style:
                                      const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: Color(
                                          0xFF0066FF,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 4),

                                    Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Row(
                                      children: [

                                        const Icon(
                                          Icons
                                              .calendar_today,
                                          size: 13,
                                          color: Colors
                                              .grey,
                                        ),

                                        const SizedBox(
                                            width: 4),

                                        Text(
                                          item.date,
                                          style:
                                          const TextStyle(
                                            color: Colors
                                                .grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _category(
      String title,
      bool selected,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 18,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          if (selected)
            Container(
              width: 40,
              height: 3,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}