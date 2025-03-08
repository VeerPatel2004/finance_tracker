import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Stats"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('transactions')
                        .where('userId', isEqualTo: _auth.currentUser?.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var transactions = snapshot.data!.docs;
                  var groupedData = _groupTransactionsByDay(transactions);

                  double maxTransactionAmount = _getMaxYValue(groupedData);

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxTransactionAmount + 500,
                      barGroups: _getBarGroups(groupedData),
                      titlesData: _getTitles(),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Group transactions by day and category
  Map<int, Map<String, double>> _groupTransactionsByDay(
    List<QueryDocumentSnapshot> transactions,
  ) {
    Map<int, Map<String, double>> groupedData = {};

    for (var transaction in transactions) {
      var data = transaction.data() as Map<String, dynamic>;

      // Firestore Timestamp to DateTime
      DateTime date =
          (data['date'] is Timestamp)
              ? (data['date'] as Timestamp).toDate()
              : DateTime.parse(data['date']);

      int day = date.day;
      String category = data['category'] ?? "Other";
      double amount = (data['amount'] ?? 0).toDouble();

      groupedData.putIfAbsent(day, () => {});
      groupedData[day]!.update(
        category,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return groupedData;
  }

  // Dynamically Calculate Max Y-Axis Value
  double _getMaxYValue(Map<int, Map<String, double>> groupedData) {
    double maxValue = 0;

    for (var dayData in groupedData.values) {
      double dayTotal = dayData.values.fold(0, (sum, value) => sum + value);
      if (dayTotal > maxValue) {
        maxValue = dayTotal;
      }
    }

    return maxValue;
  }

  // Bar Chart Data Stacked Categories
  List<BarChartGroupData> _getBarGroups(
    Map<int, Map<String, double>> groupedData,
  ) {
    List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.blueGrey,
    ];

    return List.generate(8, (index) {
      Map<String, double> dayData = groupedData[index + 1] ?? {};

      double previousHeight = 0;

      return BarChartGroupData(
        x: index,
        barRods: List.generate(dayData.keys.length, (i) {
          double currentHeight = dayData.values.elementAt(i);
          double startHeight = previousHeight;
          previousHeight += currentHeight;

          return BarChartRodData(
            fromY: startHeight,
            toY: previousHeight,
            color: colors[i % colors.length],
            width: 12,
          );
        }),
      );
    });
  }

  //Configure X & Y Axis Labels
  FlTitlesData _getTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            if (value % 1000 == 0) {
              return Text(
                "\$ ${(value / 1000).toInt()}K",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              );
            }
            return Container();
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              "0${value.toInt() + 1}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
