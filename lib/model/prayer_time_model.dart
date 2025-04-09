class PrayerTimings {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String imsak;
  final String sunrise;
  final String date;
  final String hijriDate;
  final String method;

  PrayerTimings(
      {required this.fajr,
      required this.dhuhr,
      required this.asr,
      required this.maghrib,
      required this.isha,
      required this.imsak,
      required this.sunrise,
      required this.date,
      required this.hijriDate,
      required this.method
      });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    final hijri = json['date']['hijri'];
    final String day = hijri['day']; 
    final String month = hijri['month']['en'];
    final String year = hijri['year']; 

    final gregorian = json['date']['gregorian'];
    final String gregorianDay = gregorian['day']; 
    final String gregorianMonth = gregorian['month']['en'];
    final String gregorianYear = gregorian['year']; 

    return PrayerTimings(
      fajr: json['timings']['Fajr'],
      dhuhr: json['timings']['Dhuhr'],
      asr: json['timings']['Asr'],
      maghrib: json['timings']['Maghrib'],
      isha: json['timings']['Isha'],
      imsak: json['timings']['Imsak'],
      sunrise: json['timings']['Sunrise'],
      date: "$gregorianDay $gregorianMonth $gregorianYear",
      method: json['meta']['method']['name'],
      hijriDate: "$day $month $year",
    );
  }
}
