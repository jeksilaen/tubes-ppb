import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late DatabaseReference _dbRef;
  String? filePath;
  late String author = '';
  late String publisher = '';
  late String description = '';
  late String title = '';
  late String year = '';
  late String citationText = "";

  Future<void> fetchData() async {
    late DatabaseReference _dbBook = FirebaseDatabase.instance
        .reference()
        .child('reference')
        .child('books')
        .child('book1');
    DataSnapshot snapshot = (await _dbBook.once()).snapshot;
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      setState(() {
        title = data['title'] ?? '';
        author = data['author'] ?? '';
        description = data['description'] ?? '';
        year = data['year'] ?? '';
        publisher = data['publisher'] ?? '';
      });
    }
  }

  Future<void> showCitateDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silahkan pilih jenis sitasi'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Jenis Sitasi',
                      ),
                      value: 'APA',
                      onChanged: (String? value) {
                        setState(() {
                          if (value == 'APA') {
                            citationText =
                                "$author, $title, $publisher, $year.";
                          } else if (value == 'HARVARD') {
                            citationText =
                                "$author. $year, $title, $publisher.";
                          } else if (value == 'IEEE') {
                            citationText =
                                "$author, $title, $publisher, $year.";
                          }
                        });
                      },
                      items: <String>['APA', 'HARVARD', 'IEEE']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    SelectableText(
                      citationText,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            GestureDetector(
              child: const Text(
                'Copy sitasi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: citationText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Teks telah disalin!'),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadPDF() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir.path);
    String fileName = '2.pdf';
    String localFilePath =
        '${appDocDir.path}/$fileName'; // Update the file path

    if (await File(localFilePath).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File sudah diunduh sebelumnya.'),
        ),
      );
    } else {
      String url =
          'https://repository.dinus.ac.id/docs/ajar/Software_Engineering_-_Pressman.pdf';
      HttpClient httpClient = HttpClient();

      try {
        HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
        HttpClientResponse response = await request.close();

        if (response.statusCode == 200) {
          File file = File(localFilePath);
          await file.create(
              recursive: true); // Create the file if it doesn't exist
          await response.pipe(file.openWrite());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File berhasil diunduh.'),
            ),
          );

          setState(() {
            filePath = localFilePath;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengunduh file.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan dalam mengunduh file.'),
          ),
        );
      } finally {
        httpClient.close();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.reference().child('reference');

    _dbRef.child('books').child('book1').set({
      'title': 'Software Engineering : A Practitioner Approach',
      'publisher': 'McGraw-Hill',
      'author': 'Pressman',
      'description':
          'Presents an engineering approach for the analysis, design, and testing of web applications. This book provides information on software tools, specific work flow for specific kinds of projects, and information on various topics. It includes resources for both instructors and students such as checklists, 700 categorized web references, and more.',
      'year': '2014',
    });

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Buku',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Container(
              height: 200,
              width: 150,
              margin: EdgeInsets.only(top: 12, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('image/book.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Software Engineering : \nA Practitioner Approach",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Penulis  :',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              author,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Publisher  :',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              publisher,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Year  :',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              year,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          description,
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.black,
                    ),
                    onPressed: filePath != null ? null : downloadPDF,
                    child: const Text('Download'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.black,
                    ),
                    onPressed: showCitateDialog,
                    child: const Text('Citate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
