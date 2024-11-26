import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'user_profile.dart';

class ImageApplicationScreen extends StatefulWidget {
  final int userId;
  final String firstNameOfCenter;

  const ImageApplicationScreen({
    Key? key,
    required this.userId,
    required this.firstNameOfCenter,
  }) : super(key: key);

  @override
  _ImageApplicationScreenState createState() => _ImageApplicationScreenState();
}

class _ImageApplicationScreenState extends State<ImageApplicationScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? _pickImageError;
  bool isUploading = false;

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, elija una imagen para continuar.',
            style: TextStyle(fontSize: 17),
          ),
          backgroundColor: Color(0xFFEF3030),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    } else {
      setState(() {
        isUploading = true;
      });
      String imageName = 'center${widget.userId}${widget.firstNameOfCenter}.jpg';
      try {
        final supabase = SupabaseClient(
          dotenv.env['SUPABASE_URL']!,
          dotenv.env['SUPABASE_ANON_KEY']!,
        );

        final File file = File(_imageFile!.path);
        await supabase.storage.from('imagesOfCenters').upload(imageName, file);

        // Navigate to the UserProfileScreen after upload
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              userId: widget.userId,
              isBamxAdmin: false,
            ),
          ),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error subiendo la imagen: $e',
              style: const TextStyle(fontSize: 17),
            ),
            backgroundColor: const Color(0XFFEF3030),
          ),
        );
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = image;
          _pickImageError = null;
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e.toString();
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Stack(
        children: [
          FutureBuilder<void>(
            future: Future.delayed(const Duration(seconds: 4)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(_imageFile!.path),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: _removeImage,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_pickImageError != null) {
      return Center(child: Text('Error picking image: $_pickImageError'));
    } else {
      return GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              'Subir foto',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Solicitud de Centro de Acopio',
          style: TextStyle(color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Estás a un paso de convertirte en un administrador de un Centro de Acopio',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Sube la mejor foto de tu Centro de Acopio:',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _imageFile == null
                          ? Center(
                        child: Text(
                          'Subir foto',
                          style: TextStyle(color: Colors.grey[600], fontSize: 20),
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: _previewImage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Recuerda que esta imagen será visible para todos, lúcete!!!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF3030),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUploading)
            Container(
              color: Colors.white, // Semi-transparent background
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cargando, espera por favor...',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'images/bamx-logo.png', // Replace with your image path
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}