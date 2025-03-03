import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/data/services/add_transaction_screen.dart';
import 'package:finance_tracker/data/services/transaction_service.dart';
import 'package:finance_tracker/screens/Settings_Screen/settings_screen.dart';
import 'package:finance_tracker/screens/Stats%20Screen/stats_screen.dart';
import 'package:finance_tracker/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final TransactionService transactionService = TransactionService();

  final List<Widget> _screens = [
    HomeScreen(), // Placeholder for the main Dashboard
    StatsScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
    );
  }
}

// 📌 HomeScreen (Dashboard)
class HomeScreen extends StatelessWidget {
  final TransactionService transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // ✅ User Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.person, color: Colors.black, size: 30),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "John",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  icon: const Icon(CupertinoIcons.gear_alt, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFFFF4081)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "total balance",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$ 20000.00",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Income",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\$ 2080.00",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Expense",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\$ 280.00",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "View All",
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ✅ Transactions List
            Expanded(
              child: StreamBuilder(
                stream: transactionService.getTransactions(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var transactions = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var transaction = transactions[index];
                      String category =
                          (transaction.data()
                              as Map<String, dynamic>?)?['category'] ??
                          'Other';

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: _getTransactionColor(category),
                              child: Icon(
                                _getTransactionIcon(category),
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['name'] ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  transaction['date'] ?? "No Date",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              "-\$${transaction['amount'] ?? 0}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get Icon Based on Category
  IconData _getTransactionIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.fastfood;
      case "Shopping":
        return Icons.shopping_bag;
      case "Health":
        return Icons.healing;
      case "Travel":
        return Icons.airplanemode_active;
      default:
        return Icons.money;
    }
  }

  // Get Color Based on Category
  Color _getTransactionColor(String category) {
    switch (category) {
      case "Food":
        return Colors.orange;
      case "Shopping":
        return Colors.purple;
      case "Health":
        return Colors.green;
      case "Travel":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
