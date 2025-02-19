import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  ProfilePage extends StatefulWidget {
  final String id='page id';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State< ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ لم يتم العثور على مستخدم مسجل الدخول.");
        return;
      }

      String userId = user.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        print("❌ المستخدم غير موجود في قاعدة البيانات.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a4b8f),
      body: SafeArea(
        child: Column(
          children: [
            // **Header Section**
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData?['profileImage'] != null
                        ? NetworkImage(userData!['profileImage'])
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: userData?['profileImage'] == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                        : null,
                  ),
                  SizedBox(height: 12),
                  Text(
                    userData?['username'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${userData?['age'] ?? 'N/A'} years',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    userData?['country'] ?? 'Unknown',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    userData?['phone'] ?? 'No phone number',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // **Body Section**
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Chronic Diseases",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: userData?['chronicDiseases'] != null
                          ? (userData!['chronicDiseases'] as List)
                              .map((disease) => Chip(label: Text(disease)))
                              .toList()
                          : [Text("No chronic diseases reported.")],
                    ),
                    SizedBox(height: 20),
                    Text("Last", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildAlertBox("Danger!", "Your heart rate is too low: 40 bpm.",
                              "Please seek medical help.", Colors.redAccent, "23/1/2025"),
                          _buildAlertBox("Beware!", "Emergency health condition detected:",
                              "Heart rate 180 bpm.", Colors.orangeAccent, "5/1/2025"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }

  Widget _buildAlertBox(String title, String message, String details, Color color, String date) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: color, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                Text(message, style: TextStyle(fontSize: 16)),
                Text(details, style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          Text(date, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}