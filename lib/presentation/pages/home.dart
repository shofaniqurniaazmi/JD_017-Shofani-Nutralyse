import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/common/assets/assets.dart';
import 'package:nutralyse_jd/common/config/storage.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';
import 'package:nutralyse_jd/presentation/pages/detail_gizi.dart';
import 'package:nutralyse_jd/presentation/pages/detail_rekomendasi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _authService = AuthenticationService();
  final SecureStorage _secureStorage = SecureStorage();
  String userName = "User"; // default sebelum load

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    String? name = await getUserName();
    if (name != null && name.isNotEmpty) {
      setState(() {
        userName = name;
      });
    }
  }

  Future<String?> getUserName() async {
    String? userId = await _secureStorage.getUserId();
    if (userId != null) {
      var profile = await _authService.getProfileUser(userId);
      // pakai null-aware supaya aman
      return profile?['name'] ?? 'User';
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final List<Map<String, dynamic>> rekomendasi = [
      {
        'nama': 'Bakso Ikan Tuna',
        'gambar': bakso,
        'persen': '88%',
        'kategori': 'Protein Tinggi',
        'kalori': '180 kal',
        'rating': 4.8,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
      {
        'nama': 'Sayur Sop',
        'gambar': bakso,
        'persen': '90%',
        'kategori': 'Sayuran Segar',
        'kalori': '150 kal',
        'rating': 4.9,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
      {
        'nama': 'Gado-Gado',
        'gambar': bakso,
        'persen': '85%',
        'kategori': 'Nutrisi Seimbang',
        'kalori': '220 kal',
        'rating': 4.7,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
      {
        'nama': 'Salad Buah',
        'gambar': bakso,
        'persen': '95%',
        'kategori': 'Vitamin C Tinggi',
        'kalori': '120 kal',
        'rating': 4.9,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
      {
        'nama': 'Nasi Merah',
        'gambar': bakso,
        'persen': '82%',
        'kategori': 'Karbohidrat Sehat',
        'kalori': '200 kal',
        'rating': 4.6,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
      {
        'nama': 'Smoothie Bowl',
        'gambar': bakso,
        'persen': '92%',
        'kategori': 'Antioksidan',
        'kalori': '180 kal',
        'rating': 5.0,
        'gradient': [Color(0xFFFFA726), Color(0xFFFFCC80)],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, $userName", // ✅ Sudah pakai nama login
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        "Bagaimana kesehatanmu hari ini?",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B6B).withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: isTablet ? 30 : 26,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.face,
                        color: Colors.white,
                        size: isTablet ? 32 : 28,
                      ),
                    ),
                  )
                ],
              ),
SizedBox(height: isTablet ? 30 : 24),
              // 🔹 Progress Mingguan
              _buildProgressMingguan(isTablet),

              SizedBox(height: isTablet ? 30 : 24),

              // 🔹 Donut Chart Status Gizi
              _buildDonutChart(context, isTablet),

              SizedBox(height: isTablet ? 30 : 24),

              // 🔹 Nutrient Cards
              Column(
                children: const [
                  NutrientCard(label: "Karbohidrat", percent: 80, color: Colors.green),
                  SizedBox(height: 8),
                  NutrientCard(label: "Protein", percent: 85, color: Colors.amber),
                  SizedBox(height: 8),
                  NutrientCard(label: "Lemak", percent: 35, color: Colors.red),
                  SizedBox(height: 8),
                  NutrientCard(label: "Gula", percent: 20, color: Colors.purple),
                ],
              ),

              SizedBox(height: isTablet ? 30 : 24),

              // 🔹 Rekomendasi Makanan
              _buildRekomendasiMakanan(isTablet, rekomendasi, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressMingguan(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 14, horizontal: isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF59D), Color(0xFFFFEB3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFEB3B).withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.trending_up,
              color: Colors.orange[800],
              size: isTablet ? 24 : 20,
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Progress Mingguan",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isTablet ? 18 : 16,
              color: Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context, bool isTablet) {
    return Center(
      child: GestureDetector(
        onTap: () {
          int persen = 98;
          String status = "Status Gizi";
          context.push('/detail_gizi', extra: {'persen': persen, 'status': status});
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: isTablet ? 240 : 200,
            width: isTablet ? 240 : 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 98,
                        color: Colors.green,
                        radius: isTablet ? 50 : 40,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 2,
                        color: Colors.grey[200],
                        radius: isTablet ? 50 : 40,
                        showTitle: false,
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: isTablet ? 70 : 60,
                    borderData: FlBorderData(show: false),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "98%",
                      style: TextStyle(
                        fontSize: isTablet ? 34 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "Status Gizi",
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRekomendasiMakanan(
      bool isTablet, List<Map<String, dynamic>> rekomendasi, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF8A65), Color(0xFFFFB74D)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Rekomendasi Makanan",
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isTablet ? 0.85 : 0.78,
            ),
            itemCount: rekomendasi.length,
            itemBuilder: (context, index) {
              final item = rekomendasi[index];
              return ModernFoodCard(
                item: item,
                isTablet: isTablet,
                onTap: () {
                  context.push('/detail_rekomendasi', extra: item);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// NutrientCard dan ModernFoodCard tetap sama seperti kode sebelumnya

// 🔹 NutrientCard Widget (Original)
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            "$percent%",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Modern Food Card Widget
class ModernFoodCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isTablet;
  final VoidCallback onTap;

  const ModernFoodCard({
    super.key,
    required this.item,
    required this.isTablet,
    required this.onTap,
  });

  @override
  State<ModernFoodCard> createState() => _ModernFoodCardState();
}

class _ModernFoodCardState extends State<ModernFoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Future.delayed(Duration(milliseconds: 100), widget.onTap);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.item['gradient'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.item['gradient'][0].withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: -10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating & Percentage
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    "${widget.item['rating']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.item['persen'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.item['gradient'][0],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        // Food Image
                        Center(
                          child: Container(
                            width: widget.isTablet ? 70 : 60,
                            height: widget.isTablet ? 70 : 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(widget.item['gambar']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Spacer(),

                        // Food Info
                        Text(
                          widget.item['nama'],
                          style: TextStyle(
                            fontSize: widget.isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.item['kategori'],
                          style: TextStyle(
                            fontSize: widget.isTablet ? 12 : 10,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}