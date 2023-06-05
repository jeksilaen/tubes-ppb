import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ReferenceUploadPage extends StatefulWidget {
  @override
  _ReferenceUploadPageState createState() => _ReferenceUploadPageState();
}

class _ReferenceUploadPageState extends State<ReferenceUploadPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  //final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    "UI/UX",
    "Quality Assurance",
    "Software Engineer"
  ];
  String _selectedCategory = "";
  File? _selectedFilePath = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Upload Your ',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 132, 126, 126),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Reference!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 223, 121, 37),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTextField('Title', _titleController),
              _buildTextField('Author', _authorController),
              _buildTextField('Date (dd/mm/yyyy)', _dateController),
              _buildCategoryDropdown(),
              _buildTextField('Description', _descriptionController),
              SizedBox(height: 20),
              _buildFilePicker(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 223, 121, 37)),
                ),
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    _selectedCategory = _categories[0];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        items: _categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilePicker() {
    String? selectedFilePath;
    var _selectedFile;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('File', style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedFile != null
                        ? _selectedFile.path
                        : 'No File Detected',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      selectedFilePath = result.files.single.path;
                      setState(() {
                        _selectedFile = File(selectedFilePath!);
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 223, 121, 37)),
                  ),
                  child: Text('Select', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
