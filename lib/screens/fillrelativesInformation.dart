import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectgraduation/constants/colorview.dart';
import 'package:projectgraduation/screens/homePageScreen.dart';
import 'package:projectgraduation/screens/profilePage.dart';
import 'package:projectgraduation/screens/mainScreen.dart';
class RelativesScreen extends StatefulWidget {
  const RelativesScreen({super.key, required this.userId});
  final String userId;
  @override
  State<RelativesScreen> createState() => _RelativesScreenState();
}
class _RelativesScreenState extends State<RelativesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  List<Map<String, String>> relatives = [
    {'name': '', 'number': '', 'kinship': ''},
  ];

  void addRelative() {
    setState(() {
      relatives.add({'name': '', 'number': '', 'kinship': ''});
    });
  }

  void removeRelative(int index) {
    setState(() {
      relatives.removeAt(index);
    });
  }

  void updateRelative(int index, String field, String value) {
    setState(() {
      relatives[index][field] = value;
    });
  }

  Future<void> saveRelatives() async {
    // Validate data
    for (var relative in relatives) {
      if (relative['name']!.isEmpty || 
          relative['number']!.isEmpty || 
          relative['kinship']!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields for each relative'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

try {
  // Remove the currentUser check since we have userId
  await _firestore.collection('users').doc(widget.userId).set({
    'relatives': relatives.map((relative) => {
  'name': relative['name'],
  'number': relative['number'],
  'kinship': relative['kinship'],
}).toList(),
'timestamp': FieldValue.serverTimestamp(),

  }, SetOptions(merge: true));

 
  Navigator.push(context,MaterialPageRoute(builder:(context) {
    return MainScreen();
  },));
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error saving relatives: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios, size: 20),
                   Text(
                'Tcare',
                style:TextStyle(
                  fontSize: 22,
                  fontFamily: "TimesNewRoman",
                  fontWeight: FontWeight.bold,
                  color: AppUI.colorPrimary,
                ),
              ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                Center(
                  child: const Text(
                    'Relatives',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Relatives List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: relatives.length,
                  itemBuilder: (context, index) {
                    return RelativeForm(
                      key: ValueKey(index),
                      initialData: relatives[index],
                      onRemove: () => removeRelative(index),
                      showRemoveButton: relatives.length > 1,
                      onFieldChanged: (field, value) => updateRelative(index, field, value),
                    );
                  },
                ),

                // Add Emergency Contact Button
                InkWell(
                  onTap: addRelative,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add an emergency contact',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 200),

                // Finish Button
                Center(
                  child: Container(
                    width: 130,
                    height: 45,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : saveRelatives,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppUI.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Finish',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RelativeForm extends StatelessWidget {
  final Map<String, String> initialData;
  final VoidCallback onRemove;
  final bool showRemoveButton;
  final Function(String field, String value) onFieldChanged;

  const RelativeForm({
    super.key,
    required this.initialData,
    required this.onRemove,
    required this.showRemoveButton,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Label
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Name TextField
                  TextFormField(
                    
                    initialValue: initialData['name'],
                    onChanged: (value) => onFieldChanged('name', value),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Number Label
                  const Text(
                    'Number',
                    style: TextStyle(
                       fontSize:20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Number TextField
                  TextFormField(
                    initialValue: initialData['number'],
                    onChanged: (value) => onFieldChanged('number', value),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kinship Label
                  const Text(
                    'What is your kinship to him?',
                    style: TextStyle(
                       fontSize:20,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Kinship Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: initialData['kinship'],
                      decoration: const InputDecoration(
                        hintText: 'Please specify the relationship',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('Please specify the relationship')),
                        DropdownMenuItem(value: 'parent', child: Text('Parent')),
                        DropdownMenuItem(value: 'sibling', child: Text('Sibling')),
                        DropdownMenuItem(value: 'spouse', child: Text('Spouse')),
                        DropdownMenuItem(value: 'child', child: Text('Child')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) => onFieldChanged('kinship', value ?? ''),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              if (showRemoveButton)
                Positioned(
                  top: -15,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.black45,
                      size: 20,
                    ),
                    onPressed: onRemove,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}