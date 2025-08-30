import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/common/config/env.dart';
import 'package:nutralyse_jd/common/config/storage.dart';
import 'package:nutralyse_jd/service/firebase/storage_service.dart';

class DetailCamera extends StatefulWidget {
  final String imagePath;
  final XFile image;

  DetailCamera({required this.imagePath, required this.image});

  @override
  State<DetailCamera> createState() => _DetailCameraState();
}

class _DetailCameraState extends State<DetailCamera> {
  String? responseGemini;
  Map<String, dynamic>? parsedData;
  bool isLoading = true;

  final StorageFirebaseService _storageFirebaseService = StorageFirebaseService();

  @override
  void initState() {
    super.initState();
    _processImageWithGemini(widget.image);
  }

  Future<void> _processImageWithGemini(XFile image) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKeyGemini,
    );

    try {
      var response = await model.generateContent({
        Content.multi([
          TextPart("""
Analyze this food image and return ONLY JSON (no explanation, no markdown).
Structure:
{
  "nama": "string",
  "jumlah_nutrisi": number,
  "bahan": ["string"],
  "nutrisi": {
    "Karbohidrat": number,
    "Protein": number,
    "Lemak": number,
    "Gula": number
  },
  "rincian": {
    "Kurang Sehat": ["string"],
    "Cukup Sehat": ["string"],
    "Sangat Sehat": ["string"]
  },
  "saran_menu": "string"
}
"""),
          DataPart("image/jpg", File(image.path).readAsBytesSync())
        ])
      });

      String rawText = response.text ?? "";

      // 🛠 Ambil hanya bagian JSON
      int start = rawText.indexOf("{");
      int end = rawText.lastIndexOf("}");
      String jsonString =
      (start != -1 && end != -1) ? rawText.substring(start, end + 1) : "{}";

      Map<String, dynamic> data;
      try {
        data = jsonDecode(jsonString);
      } catch (e) {
        print("Parsing error: $e");
        data = {};
      }

      // ✅ Default fallback data supaya UI gak error
      parsedData = {
        "nama": data["nama"] ?? "Makanan Tidak Dikenal",
        "jumlah_nutrisi": data["jumlah_nutrisi"] ?? 0,
        "bahan": List<String>.from(data["bahan"] ?? []),
        "nutrisi": {
          "Karbohidrat": data["nutrisi"]?["Karbohidrat"] ?? 0,
          "Protein": data["nutrisi"]?["Protein"] ?? 0,
          "Lemak": data["nutrisi"]?["Lemak"] ?? 0,
          "Gula": data["nutrisi"]?["Gula"] ?? 0,
        },
        "rincian": {
          "Kurang Sehat": List<String>.from(data["rincian"]?["Kurang Sehat"] ?? []),
          "Cukup Sehat": List<String>.from(data["rincian"]?["Cukup Sehat"] ?? []),
          "Sangat Sehat": List<String>.from(data["rincian"]?["Sangat Sehat"] ?? []),
        },
        "saran_menu": data["saran_menu"] ?? "Perbaiki pola makan dengan menu seimbang."
      };

      setState(() {
        responseGemini = jsonString;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        responseGemini = "Error processing image.";
        parsedData = null;
        isLoading = false;
      });
    }
  }

  Widget _progressBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text("$value%"),
          ],
        ),
        LinearProgressIndicator(
          value: value / 100,
          color: color,
          backgroundColor: Colors.grey[300],
          minHeight: 8,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void handleDelete() {
    try {
      File(widget.imagePath).delete();
    } catch (e) {
      print("Gagal hapus file: $e");
    }
    Navigator.pop(context);
  }

  Future<void> handleSave() async {
    String? userId = await SecureStorage().getUserId();
    String urlImage =
    await _storageFirebaseService.uploadImageToFirebase(widget.imagePath);

    bool is_successfull = await _storageFirebaseService.uploadDataArchive(
      userId!,
      urlImage,
      responseGemini ?? "",
    );

    if (is_successfull) {
      context.go('/archive');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.purple))
              : parsedData == null
              ? Center(child: Text("Format data tidak valid"))
              : ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(height: 60),
              // Foto
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.imagePath),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Nama makanan
              Center(
                child: Text(
                  parsedData!["nama"],
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              // Jumlah nutrisi
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jumlah Nutrisi"),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value:
                      (parsedData!["jumlah_nutrisi"] ?? 0) / 100,
                      color: Colors.green,
                      backgroundColor: Colors.grey[300],
                      minHeight: 10,
                    ),
                    SizedBox(height: 4),
                    Text(
                        "${parsedData!["jumlah_nutrisi"] ?? 0}% Sempurna"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Bahan
              Text("Bahan - bahan:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(
                  (parsedData!["bahan"] as List).length,
                      (i) => Chip(label: Text(parsedData!["bahan"][i])),
                ),
              ),
              SizedBox(height: 16),
              // Nilai nutrisi
              Text("Nilai Nutrisi (per Sajian):",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _progressBar("Karbohidrat",
                  parsedData!["nutrisi"]["Karbohidrat"], Colors.green),
              _progressBar("Protein",
                  parsedData!["nutrisi"]["Protein"], Colors.orange),
              _progressBar(
                  "Lemak", parsedData!["nutrisi"]["Lemak"], Colors.red),
              _progressBar("Gula",
                  parsedData!["nutrisi"]["Gula"], Colors.purple),
              SizedBox(height: 16),
              // Rincian
              Text("Rincian bahan - bahan:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...["Kurang Sehat", "Cukup Sehat", "Sangat Sehat"]
                  .map((kategori) {
                var list = parsedData!["rincian"][kategori] as List;
                if (list.isEmpty) return SizedBox();
                return Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kategori == "Kurang Sehat"
                        ? Colors.red[50]
                        : kategori == "Cukup Sehat"
                        ? Colors.yellow[50]
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kategori,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kategori == "Kurang Sehat"
                                  ? Colors.red
                                  : kategori == "Cukup Sehat"
                                  ? Colors.orange
                                  : Colors.green)),
                      SizedBox(height: 4),
                      ...list.map((item) => Text("• $item")),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              // Saran menu
              Text("Saran Perbaikan Menu:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(parsedData!["saran_menu"]),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD6D36F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  ),
                  child: const Text(
                    'Rekomendasi Menu Sehat',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
          // Tombol back & delete
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: handleDelete,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
