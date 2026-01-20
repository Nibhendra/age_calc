import 'package:flutter/material.dart';
import 'age_model.dart';
import 'package:intl/intl.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _birthDate;
  DateTime _targetDate = DateTime.now();
  Age? _age;

  void _pickDate(bool isBirthDate) async {
    DateTime initialDate = isBirthDate
        ? (_birthDate ?? DateTime(2000))
        : _targetDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _targetDate = picked;
        }
        // Result is cleared when inputs change to avoid mismatch?
        // Or re-calculate if both are valid?
        // Let's clear to force user to click calculate (satisfying feedback).
        _age = null;
      });
    }
  }

  void _calculateAge() {
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Date of Birth')),
      );
      return;
    }
    setState(() {
      _age = AgeCalculator.calculateAge(_birthDate!, _targetDate);
    });
  }

  void _clear() {
    setState(() {
      _birthDate = null;
      _targetDate = DateTime.now();
      _age = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Age Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            // Date of Birth Card
            _buildDateCard(
              title: 'Date of Birth',
              date: _birthDate,
              onTap: () => _pickDate(true),
              icon: Icons.cake,
              color: Colors.orangeAccent[100]!,
            ),
            const SizedBox(height: 20),
            // Target Date Card
            _buildDateCard(
              title: 'Age At Date',
              date: _targetDate,
              onTap: () => _pickDate(false),
              icon: Icons.today,
              color: Colors.lightBlueAccent[100]!,
            ),
            const SizedBox(height: 30),

            // Calculate Button
            ElevatedButton.icon(
              onPressed: _calculateAge,
              icon: const Icon(Icons.calculate, size: 28),
              label: const Text(
                'CALCULATE AGE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),

            const SizedBox(height: 30),

            // Result Area
            if (_age != null)
              _buildResultCard(_age!)
            else
              const Center(
                child: Text(
                  'Enter dates to calculate total age',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clear,
        backgroundColor: Colors.redAccent,
        tooltip: 'Clear All',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildDateCard({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, color.withAlpha(77)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.indigo, size: 28),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[700]!,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date == null
                        ? 'Select Date'
                        : DateFormat('dd MMM yyyy').format(date),
                    style: TextStyle(
                      color: date == null ? Colors.grey : Colors.indigo[900]!,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(Age age) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'Student Age',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAgeUnit(age.years, 'YEARS'),
              _buildDivider(),
              _buildAgeUnit(age.months, 'MONTHS'),
              _buildDivider(),
              _buildAgeUnit(age.days, 'DAYS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeUnit(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.teal.shade200);
  }
}
