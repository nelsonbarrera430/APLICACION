import 'dart:convert';
import 'package:http/http.dart' as http;

class PreguntasIAService {
  final String _apiKey = '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';
  final String _url = 'https://openrouter.ai/api/v1/chat/completions';

  Future<List<String>> generarPreguntas() async {
    final prompt = '''
Eres un experto en salud mental. Genera exactamente 5 preguntas tipo test para evaluar el nivel de ansiedad de una persona.
Escribe cada pregunta en español. Numera las preguntas del 1 al 5 claramente. No incluyas ninguna explicación adicional, solo la pregunta. Asegúrate de que las preguntas sean diferentes cada vez que se generen.
''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-r1-distill-llama-70b:free", // Ajusta el modelo si es necesario
          "messages": [
            {
              "role": "system",
              "content": "Eres un experto en salud mental. Genera exactamente 5 preguntas tipo test para evaluar el nivel de ansiedad de una persona, Escribe cada pregunta en español Numera las preguntas del 1 al 5 claramente. No incluyas ninguna explicación adicional solo la pregunta. Asegúrate de que las preguntas sean diferentes cada vez que se generen"
            },
            {
              "role": "user",
              "content": prompt
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('✅ Respuesta completa del modelo:\n$data');

        if (data is Map && data['choices'] != null && data['choices'].isNotEmpty) {
          String textoGenerado = data['choices'][0]['message']['content'] ?? '';

          if (textoGenerado.isNotEmpty) {
            print('📄 Texto generado por la IA:\n$textoGenerado');

            final preguntas = RegExp(r'^\s*(\d\.)\s+(.+)', multiLine: true)
                .allMatches(textoGenerado)
                .map((m) => m.group(2)!.trim())
                .take(5)
                .toList();

            if (preguntas.isEmpty) {
              print('⚠️ No se detectaron preguntas válidas en el texto:\n$textoGenerado');
              throw Exception('No se recibieron preguntas válidas.');
            }

            print('📋 Preguntas finales extraídas:\n$preguntas');
            return preguntas;
          } else {
            print('⚠️ No se generó contenido válido.');
            throw Exception('No se recibió contenido generado.');
          }
        } else {
          print('⚠️ La respuesta de la API no contiene la estructura esperada.');
          throw Exception('Estructura de respuesta incorrecta o vacía.');
        }
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al generar preguntas');
      }
    } catch (e) {
      print('❌ Error al conectar con OpenRouter: $e');
      rethrow;
    }
  }
}