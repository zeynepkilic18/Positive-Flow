import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:pozitivity/utils/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();

}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool dailyNotification = true;
  bool reminderNotification = false;
  bool silentMode = false;

  TimeOfDay reminderTime = const TimeOfDay(hour: 8, minute: 0); // default saat

  @override
  void initState() {
    super.initState();
    NotificationService.init();
  }

  void scheduleDailyAffirmation() async {
    if (dailyNotification) {
      final snapshot = await FirebaseFirestore.instance.collection(
          'affirmations').get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs[Random().nextInt(snapshot.docs.length)];
        final text = doc['text'];
        NotificationService.showDailyNotification(
            8, 0, "Günlük Olumlama", text, silent: silentMode);
      }
    }
  }


  void scheduleReminder() {
    if (reminderNotification) {
      NotificationService.showDailyNotification(
        reminderTime.hour,
        reminderTime.minute,
        "Hatırlatma",
        "Hatırlatıcı bildirimi",
        silent: silentMode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryLightColor = Color(0xFFF0F5F1);
    const Color primaryGreenColor = const Color.fromARGB(163, 163, 190, 164);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Bildirim Ayarları", style: TextStyle(color: Colors.black87)),
        backgroundColor: primaryLightColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: primaryLightColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile(
            title: "Günlük Olumlama Bildirimi",
            subtitle: "Her gün pozitif bir mesaj almak için aç",
            value: dailyNotification,
            onChanged: (val) {
              setState(() {
                dailyNotification = val;
                scheduleDailyAffirmation();
              });
            },
          ),
          const SizedBox(height: 10),
          _buildSwitchTile(
            title: "Hatırlatıcı Bildirimi",
            subtitle: "Belirli saatlerde hatırlatma al",
            value: reminderNotification,
            onChanged: (val) {
              setState(() {
                reminderNotification = val;
              });
              if (val) {
                pickReminderTime();
              }
            },
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreenColor,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Cihaz Bildirim Ayarlarını Aç",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> pickReminderTime() async {
    const Color primaryGreen = Color.fromARGB(163, 163, 190, 164);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black87,

            ),
            timePickerTheme: TimePickerThemeData(
              hourMinuteColor: primaryGreen.withOpacity(0.2),
              hourMinuteTextColor: Colors.black87,
              dialHandColor: primaryGreen,
              entryModeIconColor: primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != reminderTime) {
      setState(() {
        reminderTime = picked;
      });
      scheduleReminder();
    }
  }


  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    const Color greenColor = Color.fromARGB(163, 163, 190, 164);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),



          const SizedBox(width: 10),

          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color.fromARGB(163, 163, 190, 164),
            inactiveTrackColor: const Color.fromARGB(163, 163, 190, 164).withOpacity(0.4),
            onChanged: (val) async {
              onChanged(val);

              if (val == true) {
                final snapshot = await FirebaseFirestore.instance
                    .collection('affirmations')
                    .get();

                String affirmation = "Bugün harika şeyler seni bekliyor!";

                if (snapshot.docs.isNotEmpty) {
                  final doc = snapshot.docs[Random().nextInt(snapshot.docs.length)];
                  affirmation = doc['text'];
                }

                scheduleDailyAffirmation();
              }
            },
          )


        ],
      ),
    );
  }
}