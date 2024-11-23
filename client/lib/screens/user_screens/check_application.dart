import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CheckApplication extends StatefulWidget {
  final int userId;

  const CheckApplication({required this.userId, super.key});

  @override
  _CheckApplicationState createState() => _CheckApplicationState();
}

class _CheckApplicationState extends State<CheckApplication> {
  Map<String, dynamic>? applicationInfo;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkApplicationInfo();
  }

  // Function to fetch application information
  Future<void> checkApplicationInfo() async {
    try {
      final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/requests/getReqInfo');
      Map<String, dynamic> jsonData = {'userId': widget.userId.toString()};

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData is List && responseData.isNotEmpty) {
          setState(() {
            applicationInfo = responseData[0];
          });
        } else {
          setState(() {
            errorMessage = 'No se encontró información del centro.';
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Error ${response.statusCode}: no se pudo cargar la información del centro.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e - No se pudo cargar la información del centro.';
      });
    }
  }

  // Function to get icon based on completion status
  Icon getIcon(bool? completed) {
    return Icon(
      completed == true ? Icons.check : Icons.close,
      color: const Color(0xFF000000),
    );
  }

  // Function to get container color based on completion status
  Color getContainerColor(bool? completed) {
    return completed == true ? const Color(0xFF70DA67) : const Color(0xFFECF0F4);
  }

  // Function to build the list of completed courses
  List<Widget> getCompletedCourses() {
    List<Widget> items = [];

    if (applicationInfo?['acceptsMeat'] == true) {
      items.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            // Circle container with an icon
            Container(
              decoration: BoxDecoration(
                color: getContainerColor(applicationInfo?['completedCourse1']),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: getIcon(applicationInfo?['completedCourse1']),
            ),
            // Elevated button acting as a course item
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Botón de preservación de carnes presionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5FA), // Button background color
                  foregroundColor: const Color(0xFF32343E), // Text color on press
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                ),
                child: const Text(
                  "Preservación de carnes",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );
    }

    items.add(const SizedBox(height: 15));

    if(applicationInfo?['acceptsVegetables'] == true){
      items.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            // Circle container with an icon
            Container(
              decoration: BoxDecoration(
                color: getContainerColor(applicationInfo?['completedCourse2']),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: getIcon(applicationInfo?['completedCourse2']),
            ),
            // Elevated button acting as a course item
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Botón de preservación de vegetales presionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5FA), // Button background color
                  foregroundColor: const Color(0xFF32343E), // Text color on press
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                ),
                child: const Text(
                  "Preservación de vegetales",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );
    }

    items.add(const SizedBox(height: 15));

    if(applicationInfo?['acceptsCans'] == true){
      items.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            // Circle container with an icon
            Container(
              decoration: BoxDecoration(
                color: getContainerColor(applicationInfo?['completedCourse3']),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: getIcon(applicationInfo?['completedCourse3']),
            ),
            // Elevated button acting as a course item
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Botón de preservación de latas presionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5FA), // Button background color
                  foregroundColor: const Color(0xFF32343E), // Text color on press
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                ),
                child: const Text(
                  "Preservación de enlatados",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );
    }

    items.add(const SizedBox(height: 15));

    items.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            // Circle container with an icon
            Container(
              decoration: BoxDecoration(
                color: getContainerColor(applicationInfo?['completedCourse4']),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: getIcon(applicationInfo?['completedCourse4']),
            ),
            // Elevated button acting as a course item
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Organización de un centro de acopio presionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5FA), // Button background color
                  foregroundColor: const Color(0xFF32343E), // Text color on press
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                ),
                child: const Text(
                  "Organización de un centro de acopio",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
    );

    items.add(const SizedBox(height: 15));

    items.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            // Circle container with an icon
            Container(
              decoration: BoxDecoration(
                color: getContainerColor(applicationInfo?['completedCourse5']),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: getIcon(applicationInfo?['completedCourse5']),
            ),
            // Elevated button acting as a course item
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Equipo necesario presionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5FA), // Button background color
                  foregroundColor: const Color(0xFF32343E), // Text color on press
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                ),
                child: const Text(
                  "Equipo necesario",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),
                ),
              ),
            ),
            
          const SizedBox(width: 10)
          ],
        ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Estatus de la solicitud'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Cursos para tu centro de acopio',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: getCompletedCourses(),
                ),
                const SizedBox(height: 100),
                const Text("Estatus de tu solicitud: "),
                const SizedBox(height: 15),
                Container(
                  width: 400,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Pendiente",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
