import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfGeneratorPage(),
    );
  }
}

class PdfGeneratorPage extends StatefulWidget {
  @override
  _PdfGeneratorPageState createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMedicine = GlobalKey<FormState>();
  final List<Medication> _medications = [
    Medication(name: "Medicine Name", dosage: "Dosage", frequency: "Frequency", duration: "Duration")
  ];




  TextEditingController diagnosisCtrl = TextEditingController();
  TextEditingController medicineNameCtrl = TextEditingController();
  TextEditingController dosageCtrl = TextEditingController();
  TextEditingController frequencyCtrl = TextEditingController();
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController instructionsCtrl = TextEditingController();


  SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
      exportBackgroundColor: Colors.yellow,

  );

  String pathPDF = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("=====> ${_medications}");
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeaderSection(),
            _buildBodySection(),
            const SizedBox(height: 20.0),
            _buildFooterSection(),
            const SizedBox(height: 20.0),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await generatePDF();
              },
              child: Text('Generate PDF'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  pathPDF = '';
                });
              },
              child: Text('Remove PDF'),
            ),
            SizedBox(height: 20),
            if (pathPDF.isNotEmpty)
              Container(
                height: 500, // Adjust height as needed
                child: PDFView(
                  filePath: pathPDF,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  onError: (error) {
                    print(error.toString());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final name = diagnosisCtrl.text;
    final age = durationCtrl.text;

    final headerStyle =
        pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
    final mediuamStyle = pw.TextStyle(fontSize: 20);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              ///================topic Name================>
              pw.Text('Prescription', style: headerStyle),

              pw.SizedBox(height: 20),
              pw.Container(
                  height: 20, width: double.infinity, color: PdfColors.red),

              ///===================Prescription No==========>
              pw.Column(children: [
                pw.SizedBox(height: 20),
                pw.Row(children: [
                  pw.Text('Prescription No :', style: mediuamStyle),
                  pw.Text('00012145', style: mediuamStyle),
                ])
              ]),

              ///===================Prescription Date==========>
              pw.Column(children: [
                pw.SizedBox(height: 20),
                pw.Row(children: [
                  pw.Text('Prescription Date: ', style: mediuamStyle),
                  pw.Text('November 8, 2021', style: mediuamStyle),
                ])
              ]),

              pw.SizedBox(height: 20),

              pw.Container(
                  height: 15, width: double.infinity, color: PdfColors.amber),
              pw.SizedBox(height: 8),
              ///====================Patient Information============>
              pw.Text('Patient Information', style: headerStyle),
              pw.SizedBox(height: 12),

              ///===================Name and Age==========>
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.SizedBox(height: 20),
                      pw.Row(children: [
                        pw.Text('Name: ', style: mediuamStyle),
                        pw.Text('Sagor Ahamed', style: mediuamStyle),
                      ])
                    ]),
                    pw.Column(children: [
                      pw.SizedBox(height: 20),
                      pw.Row(children: [
                        pw.Text('Age: ', style: mediuamStyle),
                        pw.Text('25 Years', style: mediuamStyle),
                      ])
                    ]),
                  ]),


              ///===================Phone Number and Age==========>
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.SizedBox(height: 20),
                      pw.Row(children: [
                        pw.Text('Gender: ', style: mediuamStyle),
                        pw.Text('Male', style: mediuamStyle),
                      ])
                    ]),
                    pw.Column(children: [
                      pw.SizedBox(height: 20),
                      pw.Row(children: [
                        pw.Text('Problem: ', style: mediuamStyle),
                        pw.Text('Fever, Gastric', style: mediuamStyle),
                      ])
                    ]),
                  ]),

              pw.SizedBox(height: 12),

              pw.Container(
                  height: 15, width: double.infinity, color: PdfColors.amber),




              pw.SizedBox(height: 12),

              ///====================List of Prescribed Medications============>
              pw.Text('List of Prescribed Medications', style: headerStyle),
              pw.SizedBox(height: 12),

              pw.Table.fromTextArray(
                context: context,
                data: [
                  // Header row
                  ["Medicine Name", "Dosage", "Frequency", "Duration"],
                  // Medication rows
                  for (var medication in _medications)
                    [
                      medication.name ?? '',
                      medication.dosage ?? '',
                      medication.frequency ?? '',
                      medication.duration ?? '',
                    ],
                ],
                cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30,
                headerHeight: 40,
              ),





              ///===================Physician Name and Physician Signature==========>
              pw.Column(children: [
                pw.SizedBox(height: 20),
                pw.Row(children: [
                  pw.Text('Physician Name: ', style: mediuamStyle),
                  pw.Text('Dr. Paul', style: mediuamStyle),
                ])
              ]),
              pw.Column(children: [
                pw.SizedBox(height: 20),
                pw.Row(children: [
                  pw.Text('Physician Signature: ', style: mediuamStyle),
                  pw.Text('paul', style: mediuamStyle),
                ])
              ]),

              pw.SizedBox(height: 12),

            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final outputFilePath = "${output.path}/personal_info.pdf";
    final file = File(outputFilePath);
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pathPDF = outputFilePath;
    });
  }

  ///=========================All Ui ======================>
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
            Text("Patient Name: "),
            Expanded(child: Text("Sagor Ahamed")),
          ],
        ),
        const Row(
          children: [Text("Age: "), Expanded(child: Text("25"))],
        ),
        const Row(
          children: [Text("Gender: "), Expanded(child: Text("Male"))],
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Problem: "),
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
                    Text("  Add Medication",
                        style: TextStyle(color: Colors.black)),
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


        // Signature(
        //   controller: signatureController,
        //   width: 300,
        //   height: 300,
        //   backgroundColor: Colors.lightBlue,
        // )



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
