import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const AthkariApp());
}

class AthkariApp extends StatelessWidget {
  const AthkariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أذكاري',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Amiri',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AzkarHomePage(),
    );
  }
}

class AzkarHomePage extends StatefulWidget {
  const AzkarHomePage({super.key});

  @override
  State<AzkarHomePage> createState() => _AzkarHomePageState();
}

class _AzkarHomePageState extends State<AzkarHomePage> {
  List<String> azkar = [
    'أستغفر الله العظيم وأتوب إليه',
    'سبحان الله وبحمده، سبحان الله العظيم',
    'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
    'اللهم صل وسلم على نبينا محمد',
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا حول ولا قوة إلا بالله',
    'رب اغفر لي وتب علي إنك أنت التواب الرحيم',
    'اللهم اجعلني من التوابين واجعلني من المتطهرين',
  ];

  int currentZikrIndex = 0;
  List<int> repetitions = [];

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCounts = prefs.getString('repetitions');
    if (savedCounts != null) {
      List<dynamic> data = json.decode(savedCounts);
      repetitions = data.map((e) => e as int).toList();
    } else {
      repetitions = List.filled(azkar.length, 0);
    }
    setState(() {});
  }

  Future<void> saveCounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('repetitions', json.encode(repetitions));
  }

  void nextZikr() {
    setState(() {
      currentZikrIndex = (currentZikrIndex + 1) % azkar.length;
    });
  }

  void incrementCounter() {
    setState(() {
      repetitions[currentZikrIndex]++;
    });
    saveCounts();
  }

  void resetCurrentCounter() {
    setState(() {
      repetitions[currentZikrIndex] = 0;
    });
    saveCounts();
  }

  void addNewZikr(String newZikr) {
    setState(() {
      azkar.add(newZikr);
      repetitions.add(0);
    });
    saveCounts();
  }

  @override
  Widget build(BuildContext context) {
    int repetitionCount = repetitions.isNotEmpty ? repetitions[currentZikrIndex] : 0;
    int cycleCount = repetitionCount ~/ 33;

    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكاري'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white.withAlpha(230),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, size: 60, color: Colors.teal),
                const SizedBox(height: 20),
                Text(
                  azkar[currentZikrIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text('التكرار: $repetitionCount', style: const TextStyle(fontSize: 18)),
                Text('الدورات: $cycleCount', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: incrementCounter,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('تسبيح'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: nextZikr,
                  icon: const Icon(Icons.refresh),
                  label: const Text('ذكر آخر'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: resetCurrentCounter,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('تصـفير العداد'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newZikr = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddZikrPage()),
          );
          if (newZikr != null && newZikr is String && newZikr.isNotEmpty) {
            addNewZikr(newZikr);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة ذكر'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class AddZikrPage extends StatefulWidget {
  const AddZikrPage({super.key});

  @override
  State<AddZikrPage> createState() => _AddZikrPageState();
}

class _AddZikrPageState extends State<AddZikrPage> {
  final TextEditingController _controller = TextEditingController();

  void submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(context, text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ذكر جديد'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'اكتب الذكر هنا',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.save),
              label: const Text('إضافة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
