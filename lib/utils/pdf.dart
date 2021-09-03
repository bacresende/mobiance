// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:mobiance/utils/pdfViewer.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PDF extends StatelessWidget {
//   final doc = pw.Document();
//   writeOnpdf() {
//     doc.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: pw.EdgeInsets.all(32),
//         build: (pw.Context context) {
//           return <pw.Widget>[
//             pw.Header(level: 0, child: pw.Text("eeeeea")),
//             pw.Paragraph(text: "sssss"),
//             pw.Paragraph(text: "sssss"),
//             pw.Header(level: 1, child: pw.Text("deu certo aqui")),
//             pw.Paragraph(text: "Paragrafo doooois"),
//           ];
//         }));
//   }

//   Future savePDF() async {
//     final Directory documentDirectory =
//         await getApplicationDocumentsDirectory();

//     String documentPath = documentDirectory.path;

//     File file = File("$documentPath/example.pdf");

//     file.writeAsBytesSync(doc.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("PDF"),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.picture_as_pdf),
//               onPressed: () async {
//                 writeOnpdf();
//                 await savePDF();

//                 Directory documentDirectory =
//                     await getApplicationDocumentsDirectory();

//                 String documentPath = documentDirectory.path;

//                 String fullPath = "$documentPath/example.pdf";

//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             PdfPreviewScreen(path: fullPath)));
//                 // doc.addPage(
//                 //   pw.Page(
//                 //     build: (pw.Context context) => pw.Center(
//                 //       child: pw.Text('Hello World!'),
//                 //     ),
//                 //   ),
//                 // );

//                 // final file = File('pdf.pdf');
//                 // file.writeAsBytesSync(doc.save());
//               })
//         ],
//       ),
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/lancamentoPDF.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/generatePDF.dart';

generatePDF() {
  // HomeController homeController = Get.find();
  // homeController.lancamentos.forEach((element) {
  //   lancamentoPDF.lancamentos = element;
  // });
  // Invoice invoice = Invoice();
  // invoice.id = 00006531;
  // invoice.client =
  //     Client(name: 'Teste', address: 'Rua dos expedicionários, Centro');
  // invoice.products = [
  //   Product(name: 'Pizza Calabresa', value: 23.4, id: 1, quantity: 1),
  //   Product(name: 'Sanduíche Natual', value: 12.2, id: 7, quantity: 2),
  //   Product(name: 'Porção de Batata', value: 35.2, id: 23, quantity: 1),
  //   Product(name: 'Tábua de Carne', value: 73.9, id: 18, quantity: 1),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  //   // Product(name: 'Suco natural', value: 23.4, id: 14, quantity: 4),
  // ];
  // invoice.products.forEach((element) {
  //   invoice.total += (element.value * element.quantity);
  // });
  // GeneratePDF generatePdf = GeneratePDF(lancamento: lancamento);
  // generatePdf.generatePDFInvoice();
}
