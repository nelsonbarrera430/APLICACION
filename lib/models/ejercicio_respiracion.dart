// archivo: models/ejercicio_respiracion.dart

class EjercicioRespiracion {
  String title;
  String description;
  String gifUrl;

  EjercicioRespiracion({
    required this.title,
    required this.description,
    required this.gifUrl,
  });

  // Asegúrate de que el método fromJson esté definido correctamente.
  factory EjercicioRespiracion.fromJson(Map<String, dynamic> json) {
    return EjercicioRespiracion(
      title: json['title'],
      description: json['description'],
      gifUrl: json['gifUrl'],
    );
  }

  // Método para actualizar el gifUrl
  void setGifUrl(String newUrl) {
    gifUrl = newUrl;
  }
}
