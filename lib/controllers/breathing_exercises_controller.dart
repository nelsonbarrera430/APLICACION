import '../models/ejercicio_respiracion.dart';

class BreathingExercisesController {
  final List<EjercicioRespiracion> ejercicios;
  final Map<int, String> gifUrls = {};

  BreathingExercisesController({required this.ejercicios}) {
    _initializeGifUrls();
  }

  void _initializeGifUrls() {
    for (int i = 0; i < ejercicios.length; i++) {
      gifUrls[i] = ejercicios[i].gifUrl;
    }
  }

  void resetGif(int index) {
    gifUrls[index] = "${ejercicios[index].gifUrl}?${DateTime.now().millisecondsSinceEpoch}";
  }

  String getGifUrl(int index) {
    return gifUrls[index]!;
  }
}
