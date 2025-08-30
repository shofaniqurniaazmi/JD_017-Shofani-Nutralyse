import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRekomendasiPage extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const DetailRekomendasiPage({
    super.key,
    required this.foodData,
  });

  // Fungsi untuk membuka WhatsApp
  Future<void> _launchWhatsApp() async {
    final phoneNumber = "6282334310302"; // Ganti dengan nomor WhatsApp Anda
    final message = "Halo, saya tertarik untuk memesan ${foodData['nama']} dengan tingkat kesesuaian gizi ${foodData['persen']}. Mohon informasi lebih lanjut.";

    final whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    try {
      final Uri uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  // Data detail makanan berdasarkan nama
  Map<String, dynamic> _getDetailMakanan(String nama) {
    switch (nama) {
      case 'Bakso Ikan Tuna':
        return {
          'gambar': [
            'assets/images/bakso1.jpg',
            'assets/images/bakso2.jpg',
            'assets/images/bakso3.jpg',
          ],
          'bahan': ['Ikan Tuna segar', 'Tepung tapioka', 'Bawang putih', 'Garam', 'Merica', 'Kaldu ayam'],
          'deskripsi': 'Bakso ikan tuna yang kaya protein dan rendah lemak. Cocok untuk diet sehat dengan kandungan gizi seimbang.',
          'karbohidrat': 80,
          'protein': 85,
          'lemak': 35,
          'gula': 20,
          'harga': 'Rp 25.000',
          'porsi': '5 buah',
        };
      case 'Sayur Sop':
        return {
          'gambar': [
            'assets/images/sop1.jpg',
            'assets/images/sop2.jpg',
            'assets/images/sop3.jpg',
          ],
          'bahan': ['Wortel', 'Kentang', 'Buncis', 'Kol', 'Daging sapi', 'Bawang bombay', 'Seledri'],
          'deskripsi': 'Sayur sop segar dengan kombinasi sayuran bergizi dan daging sapi. Mengandung vitamin dan mineral penting untuk tubuh.',
          'kalori': 150,
          'karbohidrat': 75,
          'protein': 90,
          'lemak': 25,
          'gula': 15,
          'harga': 'Rp 20.000',
          'porsi': '1 mangkuk besar',
        };
      default:
        return {
          'gambar': ['assets/images/default.jpg'],
          'bahan': ['Bahan belum tersedia'],
          'deskripsi': 'Deskripsi belum tersedia',
          'kalori': 0,
          'karbohidrat': 0,
          'protein': 0,
          'lemak': 0,
          'gula': 0,
          'harga': 'Rp 0',
          'porsi': '-',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailData = _getDetailMakanan(foodData['nama']);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Rekomendasi Makanan',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Gambar Makanan (Carousel/Gallery)
            Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: PageView.builder(
                itemCount: detailData['gambar'].length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(foodData['gambar']), // Menggunakan gambar dari data yang diterima
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 Nama Makanan dan Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          foodData['nama'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          foodData['persen'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Bahan-bahan
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bahan - bahan:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...detailData['bahan'].map<Widget>((bahan) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          bahan,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Deskripsi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detailData['deskripsi'],
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Total Gizi (Donut Chart)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Gizi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Donut Chart (Simplified version)
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            foodData['persen'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'Cocok untuk Anda',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Nutrisi Details
                  NutrientBar(label: "Karbohidrat", percent: detailData['karbohidrat'], color: Colors.green),
                  const SizedBox(height: 8),
                  NutrientBar(label: "Protein", percent: detailData['protein'], color: Colors.amber),
                  const SizedBox(height: 8),
                  NutrientBar(label: "Lemak", percent: detailData['lemak'], color: Colors.red),
                  const SizedBox(height: 8),
                  NutrientBar(label: "Gula", percent: detailData['gula'], color: Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Harga dan Tombol Beli
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Harga:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        detailData['harga'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tombol Beli Sekarang
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8D88C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Beli Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 🔹 Widget NutrientBar untuk progress bar nutrisi
class NutrientBar extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const NutrientBar({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "$percent%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent / 100,
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