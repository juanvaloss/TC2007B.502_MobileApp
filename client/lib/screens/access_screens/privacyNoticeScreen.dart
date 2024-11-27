import 'package:flutter/material.dart';

class PrivacyNoticeScreen extends StatelessWidget {
  const PrivacyNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Acción del botón de regreso
          },
        ),
        elevation: 0, // Sin sombra para el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Aviso de Privacidad",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "En Kanan, nos comprometemos a proteger y respetar su privacidad. Este Aviso de Privacidad describe cómo recopilamos, utilizamos y protegemos sus datos personales cuando usa nuestra aplicación móvil. Al marcar la casilla de verificación correspondiente, usted acepta las condiciones de uso de sus datos personales establecidas en este aviso.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "1. Datos personales que recopilamos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Correo electrónico: Para identificar su cuenta y comunicarnos con usted.\n"
                    "Contraseña: Para garantizar la seguridad y el acceso único a su cuenta.\n"
                    "Ubicación: Para mostrarle centros de acopio cercanos y facilitar la logística de recolección de alimentos.\n"
                    "Solicitudes para ser centro de acopio: Para procesar su solicitud y convertir su cuenta en un centro de acopio.\n"
                    "Imágenes promocionales: Si decide subir imágenes para promocionar su centro de acopio, serán almacenadas y utilizadas dentro de la plataforma.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "2. Finalidad del uso de datos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sus datos personales serán utilizados para las siguientes finalidades:\n"
                    "- Facilitar la operación de la aplicación y mostrar centros de acopio cercanos.\n"
                    "- Procesar sus solicitudes para convertirse en un centro de acopio.\n"
                    "- Coordinar la recolección de alimentos una vez que se alcancen los límites establecidos.\n"
                    "- Mantener contacto con usted para brindarle asistencia, notificaciones u otras comunicaciones relevantes.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "3. Protección de sus datos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nos comprometemos a implementar medidas de seguridad técnicas y administrativas para proteger sus datos personales de accesos no autorizados, pérdida, o alteración. Sin embargo, ninguna plataforma es completamente segura, por lo que no podemos garantizar la seguridad absoluta de su información.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "4. Derechos de acceso, rectificación y cancelación",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Usted tiene derecho a:\n"
                    "- Acceder a los datos personales que tenemos sobre usted.\n"
                    "- Solicitar la corrección de datos inexactos.\n"
                    "- Solicitar la eliminación de sus datos personales cuando ya no sean necesarios para los fines mencionados.\n"
                    "Para ejercer estos derechos, puede contactarnos a través de [correo electrónico de contacto].",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "5. Consentimiento",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Al aceptar este Aviso de Privacidad y marcar la casilla de verificación en la aplicación, usted consiente el tratamiento de sus datos personales en los términos aquí establecidos.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "6. Modificaciones al Aviso de Privacidad",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nos reservamos el derecho de modificar este Aviso de Privacidad en cualquier momento. Las modificaciones serán notificadas a través de la aplicación.",
                style: TextStyle(fontSize: 16),
              ),

              // Botón rojo al final
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, // Botón de tamaño completo
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFEF3030), // Color rojo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Acción para regresar
                  },
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
