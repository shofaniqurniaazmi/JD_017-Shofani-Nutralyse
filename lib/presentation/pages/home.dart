import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  late Future<Map<String, dynamic>?> _userProfileFuture;
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rekomendasi = [
      {
        'nama': 'Bakso Ikan Tuna',
        'gambar': 'assets/images/bakso.png',
        'persen': '88%',
        'harga': 15000,
        'deskripsi':
        'Bakso ikan tuna yang lembut, sehat, dan bergizi. Cocok disantap dengan nasi hangat atau kuah segar.',
        'wa': '6281234567890'
      },
      {
        'nama': 'Sayur Sop',
        'gambar': 'assets/images/sayur.png',
        'persen': '90%',
        'harga': 10000,
        'deskripsi':
        'Sayur sop segar dengan sayuran pilihan yang menyehatkan. Kaya akan vitamin dan serat.',
        'wa': '6281234567890'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔹 Header (sapaan + avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Halo, Liam",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Minggu 17 Agustus",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.face, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Progress Mingguan
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Progress Mingguan",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Donut Chart Status Gizi
              Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: 98,
                              color: Colors.green,
                              radius: 40,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 2,
                              color: Colors.grey[200],
                              radius: 40,
                              showTitle: false,
                            ),
                          ],
                          sectionsSpace: 0,
                          centerSpaceRadius: 60,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "98%",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Status Gizi",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Kotak Nutrisi
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  NutrientCard(percent: 95, label: "Gula", color: Colors.purple),
                  NutrientCard(percent: 85, label: "Karbohidrat", color: Colors.green),
                  NutrientCard(percent: 80, label: "Lemak", color: Colors.red),
                  NutrientCard(percent: 75, label: "Protein", color: Colors.amber),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Menu Hari Ini
              const Text(
                "Menu Hari Ini",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              MealCard(
                title: "Sarapan",
                percent: 75,
                time: "08.00 WIB",
                food: "Nasi Goreng",
                tags: const ["Nasi", "Telur"],
                image: "assets/images/food.jpg",
              ),

              const SizedBox(height: 20),

              // 🔹 Rekomendasi Makanan
              const Text(
                "Rekomendasi Makanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                itemCount: rekomendasi.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = rekomendasi[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/detail', extra: item);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.green),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            item['gambar'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item['nama']),
                        subtitle: Text(item['persen']),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 18, color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Nutrient Card Widget
class NutrientCard extends StatelessWidget {
  final int percent;
  final String label;
  final Color color;

  const NutrientCard({
    super.key,
    required this.percent,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$percent%",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Meal Card Widget
class MealCard extends StatelessWidget {
  final String title;
  final int percent;
  final String time;
  final String food;
  final List<String> tags;
  final String image;

  const MealCard({
    super.key,
    required this.title,
    required this.percent,
    required this.time,
    required this.food,
    required this.tags,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Info makanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$percent% $food",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: tags
                        .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.grey[200],
                      labelStyle: const TextStyle(fontSize: 12),
                    ))
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
