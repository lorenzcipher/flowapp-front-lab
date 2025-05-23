import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> periods = [];
  List<String> categories = [];
  Map<String, Map<String, double>> transactionData = {};
  List<Map<String, dynamic>> forecastData = [];
  List<String> forecastDates = [];
  bool isLoading = true;
  bool isForecastLoading = false;
  String selectedPeriod = "weekly";
  bool showPredictedBalance = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    setState(() => isLoading = true);
    final url = 'https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/transactions/totals?period=$selectedPeriod';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('periods')) {
        Map<String, dynamic> periodsData = data['periods'];
        periods = periodsData.keys.toList();

        Set<String> uniqueCategories = {};
        periodsData.forEach((period, details) {
          Map<String, dynamic> categoriesData = details['categories'];
          categoriesData.keys.forEach(uniqueCategories.add);
        });
        categories = uniqueCategories.toList();

        transactionData.clear();
        periodsData.forEach((period, details) {
          Map<String, double> categoryValues = {};
          Map<String, dynamic> categoriesData = details['categories'];
          categoriesData.forEach((category, value) {
            categoryValues[category] = (value as num).toDouble();
          });
          transactionData[period] = categoryValues;
        });

        await fetchForecast();
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchForecast() async {
    setState(() => isForecastLoading = true);
    List<double> totalSpending = periods.map((period) {
      return transactionData[period]?.values.fold(0.0, (sum, value) => (sum ?? 0.0) + (value ?? 0.0)) ?? 0.0;
    }).toList();

    final url = "https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/forecast";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "account_id": "37",
        "period": selectedPeriod,
        "num_periods": periods.length,
        "total_spending": totalSpending,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        forecastData = List<Map<String, dynamic>>.from(data["forecast"]);
        forecastDates = forecastData.map((forecast) => forecast["date"] as String).toList();
        isForecastLoading = false;
      });
    } else {
      setState(() => isForecastLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4AC7D8),
        actions: [
          IconButton(
            icon: Icon(showPredictedBalance ? Icons.visibility : Icons.visibility_off, color: Colors.white),
            onPressed: () {
              setState(() {
                showPredictedBalance = !showPredictedBalance;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onSelected: (newPeriod) {
              setState(() {
                selectedPeriod = newPeriod;
                fetchTransactionData();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "weekly", child: Text("Weekly")),
              PopupMenuItem(value: "monthly", child: Text("Monthly")),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFF1A1A1A),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[800]!),
          columns: [
            DataColumn(label: Text("Category", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ...periods.map((period) => DataColumn(label: Text(period, style: TextStyle(color: Colors.white)))),
            ...forecastDates.map((date) => DataColumn(label: Text(date, style: TextStyle(color: Colors.white)))),
          ],
          rows: [
            ...categories.map((category) {
              return DataRow(
                cells: [
                  DataCell(Text(category, style: TextStyle(color: Colors.white))),
                  ...periods.map((period) {
                    double value = transactionData[period]?[category] ?? 0.0;
                    return DataCell(Text(value.toStringAsFixed(2), style: TextStyle(color: Colors.white)));
                  }),
                  ...forecastDates.map((_) => DataCell(Text("0.00", style: TextStyle(color: Colors.white)))),
                ],
              );
            }).toList(),
            DataRow(
              color: MaterialStateColor.resolveWith((states) => Color(0xFFD07AFF)),
              cells: [
                DataCell(Text("CashFlow", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ...periods.map((period) => DataCell(Text(
                  transactionData[period]?.values.fold(0.0, (sum, value) => sum + value).toStringAsFixed(2) ?? "0.00",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ))),
                ...forecastDates.map((_) => DataCell(Text("0.00", style: TextStyle(color: Colors.white)))),
              ],
            ),
            if (showPredictedBalance)
              DataRow(
                color: MaterialStateColor.resolveWith((states) => Color(0xFF573AE1)),
                cells: [
                  DataCell(Text("Forecast", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ...periods.map((_) => DataCell(Text("0.00", style: TextStyle(color: Colors.white)))),
                  ...forecastData.map((forecast) => DataCell(Text(
                    forecast["predicted_balance"].toStringAsFixed(2),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}