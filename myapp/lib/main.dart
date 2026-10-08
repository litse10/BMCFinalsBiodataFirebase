import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(15),
          ),
        ),
      ),
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final name = TextEditingController();
  final age = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final contact = TextEditingController();

  String gender = "Male";

  void saveBiodata() async {
    if (name.text.isEmpty ||
        age.text.isEmpty ||
        birthday.text.isEmpty ||
        address.text.isEmpty ||
        email.text.isEmpty ||
        contact.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill up all fields."),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("biodata").add({
      "name": name.text,
      "age": age.text,
      "birthday": birthday.text,
      "address": address.text,
      "email": email.text,
      "contact": contact.text,
      "gender": gender,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Biodata saved successfully!"),
      ),
    );

    name.clear();
    age.clear();
    birthday.clear();
    address.clear();
    email.clear();
    contact.clear();
  }

  Widget textField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Biodata",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.person,
              size: 60,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              "BIODATA FORM",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Please enter your information",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            textField(
              "Full Name",
              name,
              Icons.person,
            ),

            textField(
              "Age",
              age,
              Icons.cake,
            ),

            textField(
              "Birthday",
              birthday,
              Icons.calendar_today,
            ),

            textField(
              "Address",
              address,
              Icons.location_on,
            ),

            textField(
              "Email",
              email,
              Icons.email,
            ),

            textField(
              "Contact Number",
              contact,
              Icons.phone,
            ),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: "Gender",
                prefixIcon: const Icon(Icons.people),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveBiodata,
                icon: const Icon(Icons.save),
                label: const Text(
                  "SAVE BIODATA",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}