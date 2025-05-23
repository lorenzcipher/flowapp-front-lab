import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimulationScreen extends StatefulWidget {
  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  List<String> periods = [];
  List<String> categories = [];
  Map<String, Map<String, double>> transactionData = {};
  List<Map<String, dynamic>> forecastData = [];
  List<String> forecastDates = [];
  bool isLoading = true;
  bool isForecastLoading = false;
  String selectedPeriod = "weekly";
  bool showPredictedBalance = true;

  // Added to track simulated forecast values by category/date
  Map<String, Map<String, double>> simulatedForecastDataByCategory = {};

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    setState(() => isLoading = true);
    final url =
        'https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/transactions/totals?period=$selectedPeriod';
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
      return transactionData[period]?.values.fold(0.0, (sum, value) => sum + value) ?? 0.0;
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

  Future<void> runSimulation(List<Map<String, dynamic>> expenses) async {
    final url =
        'https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/simulate';

    final body = {
      "account_id": "37",
      "expenses": expenses,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecast = data["forecast"];

      setState(() {
        forecastDates = forecast.map((item) => item["date"] as String).toList();
        forecastData = forecast.map<Map<String, dynamic>>((item) => {
          "date": item["date"],
          "predicted_balance": item["running_balance"],
        }).toList();

        // Update local forecast data per category/date
        for (var expense in expenses) {
          String category = expense["description"];
          String date = expense["date"];
          double value = (expense["value"] as num).toDouble();

          String forecastDate = forecastDates.isNotEmpty ? forecastDates.first : date;

          if (!simulatedForecastDataByCategory.containsKey(category)) {
            simulatedForecastDataByCategory[category] = {};
          }
          if (!simulatedForecastDataByCategory[category]!.containsKey(forecastDate)) {
            simulatedForecastDataByCategory[category]![forecastDate] = 0.0;
          }
          simulatedForecastDataByCategory[category]![forecastDate] =
          (simulatedForecastDataByCategory[category]![forecastDate]! + value);
        }
      });
    } else {
      print("Simulation API failed: ${response.statusCode}");
    }
  }

  void _showAddTransactionDialog() {
    String? selectedCategory;
    double amount = 0.0;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedCategory,
                  onChanged: (newValue) => setState(() => selectedCategory = newValue),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Category"),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              ElevatedButton(
                child: Text("Select Date"),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                if (selectedCategory != null && amount != 0.0) {
                  final newExpense = {
                    "date": selectedDate.toIso8601String().split("T").first,
                    "description": selectedCategory!,
                    "value": -amount
                  };

                  await runSimulation([newExpense]);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simulation", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _showAddTransactionDialog,
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
        child: Column(
          children: [
            DataTable(
              headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
              dataRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[800]!),
              columns: [
                DataColumn(
                    label: Text("Category",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
                ...periods.map((period) => DataColumn(
                    label: Text(period,
                        style: TextStyle(color: Colors.white)))),
                ...forecastDates.map((date) => DataColumn(
                    label: Text(date,
                        style: TextStyle(color: Colors.white)))),
              ],
              rows: [
                ...categories.map((category) {
                  return DataRow(
                    cells: [
                      DataCell(Text(category,
                          style: TextStyle(color: Colors.white))),
                      ...periods.map((period) {
                        double value =
                            transactionData[period]?[category] ?? 0.0;
                        return DataCell(Text(value.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white)));
                      }),
                      ...forecastDates.map((date) {
                        double value = simulatedForecastDataByCategory[category]?[date] ?? 0.0;
                        return DataCell(Text(value.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white)));
                      }),
                    ],
                  );
                }).toList(),
                if (showPredictedBalance)
                  DataRow(
                    color: MaterialStateColor.resolveWith(
                            (states) => Colors.purpleAccent),
                    cells: [
                      DataCell(Text("Forecast",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                      ...periods.map((_) => DataCell(Text("0.00",
                          style: TextStyle(color: Colors.white)))),
                      ...forecastData.map((forecast) => DataCell(Text(
                        forecast["predicted_balance"]
                            .toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
