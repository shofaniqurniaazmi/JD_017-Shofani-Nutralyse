import 'package:flutter/material.dart';
import 'package:nutralyse_jd/service/firebase/authentication_service.dart';
import 'package:nutralyse_jd/common/config/storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthenticationService _authService = AuthenticationService();
  final SecureStorage _secureStorage = SecureStorage();

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    String? userId = await _secureStorage.getUserId();
    if (userId != null) {
      var profile = await _authService.getProfileUser(userId);
      setState(() {
        userData = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- CARD PROFILE ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE082),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.face, size: 50, color: Colors.orange),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userData?['fullName'] ?? "-",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      userData?['tanggalLahir'] ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      userData?['jenisKelamin'] == 'Laki-laki'
                          ? Icons.male
                          : Icons.female,
                      color: userData?['jenisKelamin'] == 'Laki-laki'
                          ? Colors.blue
                          : Colors.pink,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- MENU ITEMS ---
              _buildMenuItem(Icons.settings, "Pengaturan"),
              _buildMenuItem(Icons.language, "Bahasa"),
              _buildMenuItem(Icons.lock, "Privasi & Keamanan"),
              _buildMenuItem(Icons.help_outline, "FAQ"),
              const SizedBox(height: 20),

              // --- LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await _authService.logout(context); // langsung logout & move ke login
                  },
                  child: const Text(
                    "Keluar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow.shade700),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: navigate to respective screen
        },
      ),
    );
  }
}
