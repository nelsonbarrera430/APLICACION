import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class AnsiedadChart extends StatelessWidget {
  final String chartOptions;
  final bool isLoading;
  final String? errorMessage;

  const AnsiedadChart({
    Key? key,
    required this.chartOptions,
    required this.isLoading,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return Echarts(option: chartOptions);
  }
}
