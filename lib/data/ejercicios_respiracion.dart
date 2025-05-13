// archivo: data/ejercicios_respiracion.dart

import '../models/ejercicio_respiracion.dart';

const List<Map<String, dynamic>> _ejerciciosData = [
  {'title': 'El método de respiración 4-7-8', 'description': 'Inhala por 4 segundos, mantén por 4, exhala por 4 y mantén sin aire otros 4. Repite durante varios ciclos.', 'gifUrl': 'https://aarp.widen.net/content/bez9lqp9kr/web/47889.gif?animate=true&u=oymmsj'},
  {'title': 'Respiración de caja', 'description': 'Con el pulgar derecho cierra la fosa nasal derecha e inhala por la izquierda. Cierra la izquierda con el anular y exhala por la derecha. Alterna.', 'gifUrl': 'https://i.gifer.com/origin/f5/f5baef4b6b6677020ab8d091ef78a3bc_w200.gif'},
  {'title': 'Respiración con los labios fruncidos ', 'description': 'Inhala por 4 segundos, mantén el aire por 7 segundos y exhala lentamente por 8 segundos. Repite 4 veces.', 'gifUrl': 'https://aarp.widen.net/content/nytxxjjutb/web/PursedLips45.gif?animate=true&u=oymmsj'},
  {'title': 'Respiración diafragmática', 'description': 'Respira lentamente durante 5-6 segundos para inhalar y lo mismo para exhalar, manteniendo un ritmo constante.', 'gifUrl': 'https://aarp.widen.net/content/25olwot16z/web/Extended-Diaphragmatic5.gif?animate=true&u=oymmsj'},
  {'title': 'Respiración nasal alternada', 'description': 'Inhala mientras tensas un grupo muscular. Exhala y relaja el músculo. Repite con diferentes zonas del cuerpo.', 'gifUrl': 'https://aarp.widen.net/content/0dvsgtfs6u/web/AlternateNostrilBreathing4.gif?animate=true&u=oymmsj'},
];

// Conversión del Map en objetos EjercicioRespiracion usando fromJson
final List<EjercicioRespiracion> ejerciciosRespiracion = _ejerciciosData.map((data) => EjercicioRespiracion.fromJson(data)).toList();
