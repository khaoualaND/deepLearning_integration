import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class StockPredictionPage extends StatefulWidget {
  @override
  _StockPredictionPageState createState() => _StockPredictionPageState();
}

class _StockPredictionPageState extends State<StockPredictionPage> {
  TextEditingController _symbolController = TextEditingController();
  double _predictedPrice = 0.0;
  bool _isLoading = false;
  List<FlSpot> _chartData = [];

  // Function to fetch the predicted stock price from Flask API
  Future<void> _getPrediction() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'symbol': _symbolController.text}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _predictedPrice = data['predicted_price'];
        _isLoading = false;
        // Example chart data: Add dummy chart data for visualization
        _chartData = [
          FlSpot(0, _predictedPrice),
          FlSpot(1, _predictedPrice + 5), // Add a variation for chart
          FlSpot(2, _predictedPrice - 2),
          FlSpot(3, _predictedPrice + 3),
        ];
      });
    } else {
      setState(() {
        _isLoading = false;
        _predictedPrice = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch prediction')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Price Prediction'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text input for stock symbol
            TextField(
              controller: _symbolController,
              decoration: InputDecoration(
                labelText: 'Enter Stock Symbol (e.g., AAPL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Button to get prediction
            ElevatedButton(
              onPressed: _getPrediction,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Get Prediction'),
            ),
            const SizedBox(height: 20),

            // Display the predicted price
            Text(
              _isLoading
                  ? 'Loading...'
                  : 'Predicted Price: \$${_predictedPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Chart displaying the predicted stock prices
            _chartData.isNotEmpty
                ? AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 3,
                  minY: _predictedPrice - 10,
                  maxY: _predictedPrice + 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _chartData,
                      isCurved: true,
                      colors: [Colors.blue],
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            )
                : Container(),

            const SizedBox(height: 20),

            // Display predicted price in a table
            _predictedPrice != 0.0
                ? Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Stock Symbol:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_symbolController.text),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Predicted Price:'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$${_predictedPrice.toStringAsFixed(2)}'),
                      ),
                    ),
                  ],
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
