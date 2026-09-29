import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'parish_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parish Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Welcome back, Sarah!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Comprehensive Daily Readings Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border(
                left: BorderSide(color: Theme.of(context).primaryColor, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Liturgy of the Word', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                    Text(todayDate, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Feast of Saints Michael, Gabriel, and Raphael, archangels', style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.redAccent)),
                const Divider(height: 24),
                
                // First Reading
                const Text('First Reading: Revelation 12:7-12ab', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'War broke out in heaven; Michael and his angels battled against the dragon. The dragon and its angels fought back, but they did not prevail and there was no longer any place for them in heaven. The huge dragon, the ancient serpent, who is called the Devil and Satan, who deceived the whole world, was thrown down to earth, and its angels were thrown down with it.\n\nThen I heard a loud voice in heaven say: "Now have salvation and power come, and the Kingdom of our God and the authority of his Anointed. For the accuser of our brothers is cast out, who accuses them before our God day and night. They conquered him by the blood of the Lamb and by the word of their testimony; love for life did not deter them from death. Therefore, rejoice, you heavens, and you who dwell in them."',
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                ),
                const Divider(height: 30),

                // Responsorial Psalm
                const Text('Responsorial Psalm: Psalm 138:1-2ab, 2cde-3, 4-5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'R. In the sight of the angels I will sing your praises, Lord.\n\nI will give thanks to you, O LORD, with all my heart, for you have heard the words of my mouth; in the presence of the angels I will sing your praise; I will worship at your holy temple and give thanks to your name.',
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                ),
                const Divider(height: 30),

                // Gospel
                const Text('Gospel: John 1:47-51', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'Jesus saw Nathanael coming toward him and said of him, "Here is a true child of Israel. There is no duplicity in him." Nathanael said to him, "How do you know me?" Jesus answered and said to him, "Before Philip called you, I saw you under the fig tree." Nathanael answered him, "Rabbi, you are the Son of God; you are the King of Israel." Jesus answered and said to him, "Do you believe because I told you that I saw you under the fig tree? You will see greater things than this." And he said to him, "Amen, amen, I say to you, you will see heaven opened and the angels of God ascending and descending on the Son of Man."',
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Home Church
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Icon(Icons.church, color: Theme.of(context).primaryColor),
            title: const Text('My Home Church'),
            subtitle: const Text("St. Patrick's"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ParishProfileScreen())),
          ),
        ],
      ),
    );
  }
}