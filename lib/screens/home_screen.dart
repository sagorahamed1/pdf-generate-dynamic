import 'package:flutter/material.dart';
import 'package:pdf_make/models/patients_model.dart';

import '../models/invoice.dart';
import '../pdf_api/pdf_api.dart';
import '../pdf_api/pdf_invoice.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMedicine = GlobalKey<FormState>();
  final List<Medication> _medications = [];

  TextEditingController diagnosisCtrl = TextEditingController();
  TextEditingController medicineNameCtrl = TextEditingController();
  TextEditingController dosageCtrl = TextEditingController();
  TextEditingController frequencyCtrl = TextEditingController();
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController instructionsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildHeaderSection(),
              _buildBodySection(),
              const SizedBox(height: 20.0),
              _buildFooterSection(),
              const SizedBox(height: 20.0),


              ElevatedButton(
                onPressed: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(const Duration(days: 7));

                  final invoice = Invoice(
                    supplier: const Supplier(
                      name: 'Sarah Field',
                      address: 'Sarah Street 9, Beijing, China',
                      paymentInfo: 'https://paypal.me/sarahfieldzz',
                    ),
                    customer: const Customer(
                      name: 'Apple Inc.',
                      address: 'Apple Street, Cupertino, CA 95014',
                    ),
                    info: InvoiceInfo(
                      date: date,
                      dueDate: dueDate,
                      description: 'My description...',
                      number: '${DateTime.now().year}-9999',
                    ),
                    items: [
                      InvoiceItem(
                        description: 'Coffee',
                        date: DateTime.now(),
                        quantity: 3,
                        vat: 0.19,
                        unitPrice: 5.99,
                      ),
                      InvoiceItem(
                        description: 'Water',
                        date: DateTime.now(),
                        quantity: 8,
                        vat: 0.19,
                        unitPrice: 0.99,
                      ),
                      InvoiceItem(
                        description: 'Orange',
                        date: DateTime.now(),
                        quantity: 3,
                        vat: 0.19,
                        unitPrice: 2.99,
                      ),
                      InvoiceItem(
                        description: 'Apple',
                        date: DateTime.now(),
                        quantity: 8,
                        vat: 0.19,
                        unitPrice: 3.99,
                      ),
                      InvoiceItem(
                        description: 'Mango',
                        date: DateTime.now(),
                        quantity: 1,
                        vat: 0.19,
                        unitPrice: 1.59,
                      ),
                      InvoiceItem(
                        description: 'Blue Berries',
                        date: DateTime.now(),
                        quantity: 5,
                        vat: 0.19,
                        unitPrice: 0.99,
                      ),
                      InvoiceItem(
                        description: 'Lemon',
                        date: DateTime.now(),
                        quantity: 4,
                        vat: 0.19,
                        unitPrice: 1.29,
                      ),
                    ],
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  PdfApi.openFile(pdfFile);
                },
                child: const Text('Submit Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Patient’s Information",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        const SizedBox(height: 16.0),
        const Row(
          children: [
            Text("Patient Name : "),
            Expanded(child: Text("Sagor Ahamed")),
          ],
        ),
        const Row(
          children: [Text("Age : "), Expanded(child: Text("25"))],
        ),
        const Row(
          children: [Text("Gender : "), Expanded(child: Text("Male"))],
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Problem : "),
            Expanded(
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        const Text(
          "Diagnosis",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Diagnosis',
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Please enter diagnosis';
            return null;
          },
          controller: diagnosisCtrl,
        ),
      ],
    );
  }

  Widget _buildBodySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Medications",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        const SizedBox(height: 20.0),
        Column(
          children: _medications.map((medication) {
            int index = _medications.indexOf(medication);
            return Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(medication.name ?? ""),
                        Text(medication.dosage ?? ""),
                        Text(medication.frequency ?? ""),
                        Text(medication.duration ?? ""),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _medications.removeAt(index);
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
        Form(
          key: _formKeyMedicine,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Medicine Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter medicine name';
                  return null;
                },
                controller: medicineNameCtrl,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Dosage',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter dosage';
                  return null;
                },
                controller: dosageCtrl,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Frequency',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter frequency';
                  return null;
                },
                controller: frequencyCtrl,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Duration',
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter duration';
                  return null;
                },
                controller: durationCtrl,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              if (_formKeyMedicine.currentState!.validate()) {
                _medications.add(
                  Medication(
                    name: medicineNameCtrl.text,
                    dosage: dosageCtrl.text,
                    frequency: frequencyCtrl.text,
                    duration: durationCtrl.text,
                  ),
                );
                setState(() {});
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 16.0),
              width: 220.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.black),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    Text("  Add Medication", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instructions",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Instructions',
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Please enter instructions';
            return null;
          },
          controller: instructionsCtrl,
        ),
      ],
    );
  }
}

class Medication {
  String? name;
  String? dosage;
  String? frequency;
  String? duration;

  Medication({this.name, this.dosage, this.frequency, this.duration});
}
