import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        backgroundColor: const Color(0xFFFFE082),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: isTablet ? 28 : 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hari Ini",
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FoodDetailPage()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nasi Goreng",
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "75%",
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Nasi Goreng",
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _IngredientChip(label: "Nasi", isTablet: isTablet),
                                      _IngredientChip(label: "Telur", isTablet: isTablet),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isTablet ? 20 : 16),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: isTablet ? 18 : 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${8 + index}:${(index * 15) % 60 < 10 ? '0' : ''}${(index * 15) % 60}",
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: isTablet ? 80 : 60,
                                    height: isTablet ? 80 : 60,
                                    color: Colors.orange[100],
                                    child: Icon(
                                      Icons.restaurant,
                                      size: isTablet ? 36 : 30,
                                      color: Colors.orange[400],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

// Halaman detail makanan responsif
class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({Key? key}) : super(key: key);

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  bool isKurangSehatExpanded = false;
  bool isCukupSehatExpanded = false;
  bool isSangatSehatExpanded = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: isTablet ? 28 : 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black, size: isTablet ? 28 : 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: isTablet ? 300 : 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                "Salad",
                style: TextStyle(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isTablet ? 24 : 16),
              Container(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Jumlah Nutrisi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "98%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: isTablet ? 18 : 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "SEHAT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Text(
                "Bahan - bahan:",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Wrap(
                spacing: isTablet ? 12 : 8,
                runSpacing: isTablet ? 12 : 8,
                children: const [
                  _IngredientChip(label: "Telur", isTablet: false),
                  _IngredientChip(label: "Jagung", isTablet: false),
                  _IngredientChip(label: "Brokoli", isTablet: false),
                  _IngredientChip(label: "Wortel", isTablet: false),
                  _IngredientChip(label: "Selada", isTablet: false),
                  _IngredientChip(label: "Timun", isTablet: false),
                  _IngredientChip(label: "Kacang", isTablet: false),
                ],
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Text(
                "Nilai Nutrisi (per Sajian):",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
              _NutritionBar(label: "Karbohidrat", percentage: 80, color: Colors.green, isTablet: isTablet),
              SizedBox(height: isTablet ? 16 : 12),
              _NutritionBar(label: "Protein", percentage: 85, color: Colors.orange, isTablet: isTablet),
              SizedBox(height: isTablet ? 16 : 12),
              _NutritionBar(label: "Lemak", percentage: 35, color: Colors.red, isTablet: isTablet),
              SizedBox(height: isTablet ? 16 : 12),
              _NutritionBar(label: "Gula", percentage: 20, color: Colors.grey, isTablet: isTablet),
              SizedBox(height: isTablet ? 32 : 24),
              Text(
                "Rincian bahan - bahan:",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
              _buildDetailSection(
                "Kurang Sehat",
                Colors.red[100]!,
                [],
                isKurangSehatExpanded,
                    () => setState(() => isKurangSehatExpanded = !isKurangSehatExpanded),
                isTablet,
              ),
              SizedBox(height: 8),
              _buildDetailSection(
                "Cukup Sehat",
                Colors.yellow[100]!,
                [],
                isCukupSehatExpanded,
                    () => setState(() => isCukupSehatExpanded = !isCukupSehatExpanded),
                isTablet,
              ),
              SizedBox(height: 8),
              _buildDetailSection(
                "Sangat Sehat",
                Colors.green[100]!,
                [
                  "Selada - rendah kalori, tinggi vitamin (A, C, K), kaya air.",
                  "Jagung - karbohidrat kompleks, serat baik untuk pencernaan.",
                ],
                isSangatSehatExpanded,
                    () => setState(() => isSangatSehatExpanded = !isSangatSehatExpanded),
                isTablet,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, Color color, List<String> items, bool isExpanded,
      VoidCallback onTap, bool isTablet) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: Colors.grey[600],
                  size: isTablet ? 28 : 24,
                ),
              ],
            ),
            if (isExpanded && items.isNotEmpty) ...[
              SizedBox(height: isTablet ? 16 : 12),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "• $item",
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              )),
            ],
            if (isExpanded && items.isEmpty) ...[
              SizedBox(height: isTablet ? 16 : 12),
              Text(
                "Tidak ada bahan yang masuk dalam kategori ini.",
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget IngredientChip responsif
class _IngredientChip extends StatelessWidget {
  final String label;
  final bool isTablet;
  const _IngredientChip({required this.label, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12, vertical: isTablet ? 10 : 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isTablet ? 14 : 12,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Widget NutritionBar responsif
class _NutritionBar extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;
  final bool isTablet;

  const _NutritionBar({
    required this.label,
    required this.percentage,
    required this.color,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 16 : 14,
                color: Colors.black87,
              ),
            ),
            Text(
              "$percentage%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 8 : 6),
        Container(
          height: isTablet ? 10 : 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
