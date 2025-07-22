import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_app/Enums/CigaretteType.dart';
import 'package:flutter_project_app/components/HeaderPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_project_app/model/CigaretteModel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedPeriod = "This Week";

  int _counter = 0;

  List<Cigarettemodel> dummyData = [
    Cigarettemodel(
        month: 1, infoAbout: "Fumo mattutino", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 1, infoAbout: "Pausa pranzo", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 2, infoAbout: "Serata con amici", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 2, infoAbout: "Rilassante", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 3, infoAbout: "Fumo occasionale", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 7, infoAbout: "Stress lavoro", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 7, infoAbout: "Dopo cena", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 5, infoAbout: "Fine settimana", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 5, infoAbout: "Giornata fredda", type: CigaretteType.REGULAR),
    Cigarettemodel(
        month: 6, infoAbout: "Relax serale", type: CigaretteType.REGULAR),
  ];

  List<FlSpot> getMonthlySpots(List<Cigarettemodel> data) {
    final now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    _counter = 0;

    // Filtra solo i dati del mese e anno corrente
    final filtered = data.where((c) =>
        c.timestamp.month == currentMonth && c.timestamp.year == currentYear);

    // Mappa giorno → somma quantità
    final Map<int, int> quantityPerDay = {};

    for (var item in filtered) {
      int day = item.timestamp.day;
      quantityPerDay[day] = (quantityPerDay[day] ?? 0) + item.quantity;
    }

    // Ottieni giorni del mese corrente
    int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    // Crea un FlSpot per ogni giorno del mese
    return List.generate(daysInMonth, (index) {
      int day = index + 1;
      double quantity = (quantityPerDay[day] ?? 0).toDouble();
      _counter += quantity.toInt(); // Aggiorna il contatore
      return FlSpot(day.toDouble(), quantity);
    });
  }

  List<FlSpot> getWeeklyFlSpots(List<Cigarettemodel> data) {
    final now = DateTime.now();

    _counter = 0;

    // Calcola il lunedì e la domenica della settimana corrente
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    // Crea una mappa per sommare quantità per giorno
    Map<int, double> quantitiesByWeekday = {
      for (int i = 1; i <= 7; i++) i: 0,
    };

    // Filtra dati solo nella settimana corrente e somma quantità per giorno della settimana
    for (final item in data) {
      final d = item.timestamp;
      if (!d.isBefore(monday) && !d.isAfter(sunday)) {
        int weekday = d.weekday; // 1 = lunedì, 7 = domenica
        quantitiesByWeekday[weekday] =
            quantitiesByWeekday[weekday]! + item.quantity;
      }
    }

    // Crea lista di FlSpot per tutti i 7 giorni (x = giorno, y = quantità o 0)
    List<FlSpot> spots = [];
    for (int i = 1; i <= 7; i++) {
      spots.add(FlSpot(i.toDouble(), quantitiesByWeekday[i]!));
      _counter += quantitiesByWeekday[i]!.toInt(); // Aggiorna il contatore
    }

    return spots;
  }

  Widget _buildChart() {
    List<FlSpot> spots = _selectedPeriod == "This Month"
        ? getMonthlySpots(dummyData)
        : getWeeklyFlSpots(dummyData);

    return SizedBox(
        height: 140,
        width: double.infinity,
        child: LineChart(
          LineChartData(
            backgroundColor: CupertinoColors.transparent,
            gridData: const FlGridData(
              show: false,
            ),
            lineTouchData: const LineTouchData(
              enabled:
                  false, // disabilita completamente il touch (tooltip incluso)
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 15,
                  getTitlesWidget: (value, meta) {
                    final int day = value.toInt();
                    final int lastDay = spots.length;

                    final List<int> daysToShow = (_selectedPeriod == "This Week"
                            ? [1, 7]
                            : [1, spots.length])
                        .where((d) => d <= lastDay) // evita overflow
                        .toList();

                    if (daysToShow.contains(day)) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 5), // sposta il testo in basso
                        child: Text(
                          //   (_selectedPeriod == "This Week" ? "$day" : "$day ${DateFormat.MMM("it").format(DateTime.now()).toUpperCase()}"),
                          "$day",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors
                                .systemGrey, // o CupertinoColors.black se vuoi stile iOS
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 1,
            maxX: spots.length.toDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: CupertinoColors.activeBlue,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: CupertinoColors.activeBlue.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ));
  }

  final int smokedToday = 15;
  final int maxAllowed = 20;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Headerpage(title: "Riepilogo", showDate: true),
            CupertinoPopupSurface(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemBackground
                      .resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sigarette",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$smokedToday fumate",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const double spacing = 2.0;
                        final totalSpacing = spacing * (maxAllowed - 1);
                        final availableWidth =
                            constraints.maxWidth - totalSpacing;
                        final size = availableWidth / maxAllowed;

                        final double barHeight = 8;
                        final double barVerticalCenter =
                            size / 2 - barHeight / 2;

                        final double barWidth =
                            (smokedToday / maxAllowed) * constraints.maxWidth;

                        return SizedBox(
                          height: size,
                          child: Stack(
                            children: [
                              Positioned(
                                left: -2,
                                top: -2,
                                child: Container(
                                  width: barWidth + 4,
                                  height: size + 4,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.activeGreen,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              // Row dei cerchi dietro la barra
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(maxAllowed, (index) {
                                  Color color;
                                  if (index < smokedToday) {
                                    color =
                                        const Color.fromARGB(255, 34, 81, 45);
                                  } else {
                                    color =
                                        const Color.fromARGB(255, 131, 91, 36);
                                  }

                                  return Container(
                                    width: size,
                                    height: size,
                                    margin: EdgeInsets.only(
                                        right: index != maxAllowed - 1
                                            ? spacing
                                            : 0),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                              // Barra luminosa davanti ai cerchi
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "0",
                          style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text('$smokedToday',
                            style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 12)),
                        const Text('20',
                            style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
