import 'package:flutter/material.dart';

class ParishListScreen extends StatelessWidget {
  const ParishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover Parishes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Container(
                      width: 60, height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    title: const Text("St. Patrick's Parish", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('37 S. Patrick Address\nConfession: Sat 4 PM'),
                    trailing: Chip(
                      label: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 10)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParishProfileScreen())),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ParishProfileScreen extends StatelessWidget {
  const ParishProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("St. Patrick's Parish Profile")),
      body: ListView(
        children: [
          Container(height: 200, color: Colors.grey[400], child: const Center(child: Text('Church Image Here'))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('St. Patrick Parish\n22035 Wetcolit'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contact Info', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('(333) 257-7785', style: TextStyle(color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 40),
                const Text('Service Times', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _ServiceTimeRow('Sunday', '9:00 AM, 11:00 AM'),
                _ServiceTimeRow('Monday', '8:00 AM'),
                _ServiceTimeRow('Thursday', '12:00 PM'),
                const Divider(height: 40),
                const Text('Recent News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Join us for the upcoming youth retreat next weekend. Please register at the parish office."),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ServiceTimeRow extends StatelessWidget {
  final String day;
  final String time;
  const _ServiceTimeRow(this.day, this.time);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(day), Text(time, style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }
}