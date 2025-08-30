import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutralyse_jd/common/config/env.dart';
import 'package:nutralyse_jd/presentation/pages/detail_kamera1.dart';
import 'package:nutralyse_jd/presentation/widget/loading_dialog.dart';
import 'package:nutralyse_jd/service/firebase/storage_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';


class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? cameraController;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
      await cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!cameraController!.value.isInitialized) return;

    try {
      final XFile picture = await cameraController!.takePicture();
      setState(() {
        imagePath = picture.path;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCamera(
            imagePath: picture.path,
            image: picture,
          ),
        ),
      );
    } on CameraException catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCamera(
            imagePath: pickedFile.path,
            image: pickedFile,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: const Text(
          "Camera",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(cameraController!),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol close
                IconButton(
                  icon: const Icon(Icons.close, size: 32, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Tombol capture (besar di tengah)
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.black54, width: 3),
                    ),
                  ),
                ),
                // Tombol galeri
                IconButton(
                  icon: const Icon(Icons.photo, size: 32, color: Colors.black54),
                  onPressed: _pickFromGallery,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
