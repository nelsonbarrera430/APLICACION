import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatIAService {
  final String _apiKey = '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';
  final String _url = 'https://openrouter.ai/api/v1/chat/completions';
  final String _model = "deepseek/deepseek-r1-distill-llama-70b:free";
  final String _httpReferer = 'https://tuapp.com';
  final String _xTitle = 'CHIP - Asistente de Ansiedad';

  Future<String> enviarMensaje(String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': _httpReferer,
          'X-Title': _xTitle,
        },
        body: jsonEncode({
          "model": _model,
          "messages": [
            {
              "role": "system",
              "content":
                  "Eres CHIP, un asistente virtual que actúa como un psicólogo empático y comprensivo, especializado en brindar apoyo emocional para la ansiedad y el estrés. Tu objetivo principal es escuchar atentamente al usuario, reflejar sus sentimientos para asegurar la comprensión ('Entiendo que te sientes...'), ofrecer estrategias prácticas y concisas basadas en técnicas de relajación, mindfulness y principios de la terapia cognitivo-conductual. Prioriza la brevedad y la claridad en tus respuestas, yendo directamente al punto sin divagaciones. Adapta tus respuestas a la situación específica que el usuario describe. Sugiere ejercicios concretos (por ejemplo, 'Podríamos intentar un ejercicio de respiración ahora mismo...') o técnicas de afrontamiento específicas. Recuerda al usuario sus fortalezas y su capacidad para manejar sus emociones. Evita dar consejos médicos o terapéuticos profundos; si la situación lo requiere, recomienda buscar la guía de un profesional de la salud mental. Mantén un tono profesional, cálido y de apoyo.",
            },
            {
              "role": "user",
              "content": mensaje,
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data != null && data['choices'] != null && data['choices'].isNotEmpty) {
          String respuesta = data['choices'][0]['message']['content'].trim();
          return respuesta;
        } else {
          return 'CHIP está aquí. A veces las palabras son difíciles de encontrar. ¿Cómo te sientes exactamente en este momento?';
        }
      } else {
        print('Error de la API: ${response.statusCode}, body: ${response.body}');
        return 'CHIP tuvo una dificultad para responder. ¿Podrías intentar tu pregunta de nuevo?';
      }
    } catch (e) {
      print('Error de conexión: $e');
      return 'CHIP no pudo conectarse. Por favor, verifica tu conexión a internet.';
    }
  }
}