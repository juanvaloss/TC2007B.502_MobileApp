import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfoCenter extends StatefulWidget {
  final int userId;
  final int centerId;
  final LatLng currentUserPosition;
  final LatLng centerPosition;

  const MoreInfoCenter(
      {required this.userId,
      super.key,
      required this.centerId,
      required this.currentUserPosition,
      required this.centerPosition});

  @override
  _MoreInfoCenterState createState() => _MoreInfoCenterState();
}

class _MoreInfoCenterState extends State<MoreInfoCenter> {
  Map<String, dynamic> centerInfo = {};
  String errormessage = '';
  double result = 0.0;
  Uint8List? _imageFile;
  late var centerAdmin;
  late var firstNameOfC;

  @override
  void initState() {
    super.initState();
    futureCenterInfo();
  }

  Future<void> futureCenterInfo() async {
    try {
      final url =
          Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/centers/centerInfo');

      Map<String, dynamic> jsonData = {'centerId': widget.centerId};

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          centerInfo = responseData;
          centerAdmin = responseData['centerAdmin'];
          firstNameOfC =
              removeDiacritics(responseData['centerName'].split(' ').first);
        });

        setState(() {
          result = (100 * (centerInfo['currentCapacity'] ?? 0)) /
              ((centerInfo['totalCapacity'] ?? 1).toDouble());
        });

        final supabase = SupabaseClient(
            dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_ANON_KEY']!);
        final storageResponse = await supabase.storage
            .from('imagesOfCenters')
            .download('center${centerAdmin}${firstNameOfC}.jpg');

        setState(() {
          _imageFile = storageResponse;
        });
      } else {
        setState(() {
          errormessage =
              'Error ${response.statusCode}: no se pudo cargar la información del centro.';
        });
      }
    } catch (e) {
      setState(() {
        errormessage =
            'Error ${e}: no se pudo cargar la información del centro ayuda.';
      });
    }
  }

  String removeDiacritics(String str) {
    var withDiacritics = 'áéíóúÁÉÍÓÚ';
    var withoutDiacritics = 'aeiouAEIOU';

    String result = '';

    for (int i = 0; i < str.length; i++) {
      int index = withDiacritics.indexOf(str[i]);
      if (index != -1) {
        result += withoutDiacritics[index];
      } else {
        result += str[i];
      }
    }

    return result;
  }

  IconData getIcon() {
    if (result < 30) {
      return Icons.sentiment_dissatisfied_outlined;
    } else if (result >= 30 && result < 70) {
      return Icons.sentiment_neutral_outlined;
    } else {
      return Icons.sentiment_satisfied_alt_outlined;
    }
  }

  Color getColor() {
    if (result < 30) {
      return const Color(0XFFEF3030);
    } else if (result >= 30 && result < 70) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  List<Widget> getAcceptedItems() {
    List<Widget> items = [];

    if (centerInfo['acceptsMeat'] == true) {
      items.add(
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEF3030),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                FontAwesomeIcons.drumstickBite,
                color: Colors.white,
                size: 40,
              ),
            ),
            const Text(
              'Carne',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (centerInfo['acceptsVegetables'] == true) {
      items.add(
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEF3030),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                FontAwesomeIcons.carrot,
                color: Colors.white,
                size: 40,
              ),
            ),
            const Text(
              'Vegetales',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (centerInfo['acceptsCans'] == true) {
      items.add(
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEF3030),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                FontAwesomeIcons.bucket,
                color: Colors.white,
                size: 40,
              ),
            ),
            const Text(
              'Latas',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Información del centro'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: _imageFile != null
                    ? DecorationImage(
                        image: MemoryImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[200],
              ),
              child: _imageFile == null
                  ? const Center(child: CircularProgressIndicator())
                  : null,
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${centerInfo['centerName'] ?? 'No disponible'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dirección: ${centerInfo['centerAddress'] ?? 'No disponible'}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
            ),
            if (errormessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errormessage,
                    style: const TextStyle(color: Color(0XFFEF3030)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  getIcon(),
                  color: getColor(),
                  size: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  '${result.round()}% lleno',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Acepta: ',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getAcceptedItems(),
            ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF3030),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    Uri googleMapsUrl = Uri.parse(
                        "https://www.google.com/maps/dir/?api=1&origin=${widget.currentUserPosition.latitude},${widget.currentUserPosition.longitude}&destination=${widget.centerPosition.latitude},${widget.centerPosition.longitude}&travelmode=driving");
                    if (await canLaunchUrl(googleMapsUrl)) {
                      await launchUrl(googleMapsUrl);
                    } else {
                      throw 'Could not launch $googleMapsUrl';
                    }
                  },
                  child: const Text(
                    'ENCONTRAR RUTA',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
