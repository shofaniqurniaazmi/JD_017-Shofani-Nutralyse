import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/common/config/storage.dart';
import 'dart:io';
import 'package:nutralyse_jd/presentation/widget/loading_dialog.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';
import 'package:nutralyse_jd/service/firebase/storage_service.dart';

class DetailCamera2 extends StatefulWidget {
  final String imagePath;
  final String responseGemini;
  final XFile image; // Data nutrisi

  DetailCamera2({
    required this.imagePath,
    required this.responseGemini,
    required this.image,
  });

  @override
  State<DetailCamera2> createState() => _DetailCamera2State();
}

class _DetailCamera2State extends State<DetailCamera2> {
  StorageFirebaseService _storageFirebaseService = StorageFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Your Food'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 40), // Space to push the image to the middle top
            Center(
              child: Image.file(
                File(widget.imagePath),
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 16.0), // Space between image and description
            Text(
              // "Lorem ipsum odor amet, consectetuer adipiscing elit. Proin nam suscipit, hendrerit diam elementum mattis. Eleifend vehicula justo fames suscipit dui id. Sociosqu vel lectus odio purus vulputate elit etiam convallis ante. Commodo viverra dis imperdiet vel tortor accumsan aptent. Massa penatibus non placerat vulputate montes tincidunt cursus. In quis class purus nibh eu nascetur ut. Dolor fermentum ut nec aptent sem lacus imperdiet iaculis nascetur. Lorem porttitor parturient placerat mauris natoque. Quis eget malesuada facilisis pulvinar netus arcu. Mollis nisl elit himenaeos condimentum eu arcu amet elementum. Sagittis ex est habitasse at varius feugiat consectetur ridiculus. Suscipit cursus libero conubia sagittis est imperdiet, blandit odio dapibus. Augue est vehicula vel laoreet finibus convallis. Vel per nibh odio gravida justo ridiculus natoque sapien sagittis. Bibendum vehicula fames pharetra curabitur finibus nulla etiam netus. Amet luctus urna nam leo odio. Augue consectetur vulputate dui taciti tempor felis per nostra. Ante aenean risus hac phasellus orci. Ornare aliquam pretium potenti a augue massa class vulputate. Dis non curae ut sapien vel aptent class cras? Tempus mi augue lectus magna vivamus amet. Purus ex fermentum risus ornare augue convallis metus. Vehicula dui maximus porta sagittis volutpat et aptent. Augue natoque malesuada sapien phasellus aptent cursus mus eleifend metus. Quis ex magnis urna; placerat sagittis purus.",
              '${widget.responseGemini}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
            SizedBox(
                height: 16.0), // Space between description and nutritional data
            // NutritionalData(nutritionalData: nutritionalData), // Pass data nutrisi
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String? userId = await SecureStorage().getUserId();
                  String urlImage = await _storageFirebaseService
                      .uploadImageToFirebase(widget.imagePath);
                  bool is_successfull =
                  await _storageFirebaseService.uploadDataArchive(
                      userId!, urlImage, widget.responseGemini);
                  if (is_successfull) {
                    context.go('/archive');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: Text(
                  'SAVE',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 40), // Space below the button
          ],
        ),
      ),
    );
  }
}
