import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AppointmentsScreenContent();
  }
}

class _AppointmentsScreenContent extends StatefulWidget {
  @override
  State<_AppointmentsScreenContent> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<_AppointmentsScreenContent> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevular'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Takvim widget'ı
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),

            // Randevu listesi başlığı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Randevularım',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Yeni randevu ekleme sayfasına yönlendirme
                      print('Yeni randevu ekle');
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Yeni Randevu'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Randevu listesi
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    // Örnek randevu verileri
    final appointments = _getAppointmentsForDate(_selectedDate);

    if (appointments.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_available, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Bu tarihte randevunuz bulunmuyor',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Yeni randevu oluşturmak için + butonuna tıklayın',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getStatusColor(appointment['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.content_cut,
                color: _getStatusColor(appointment['status']),
                size: 24,
              ),
            ),
            title: Text(
              appointment['salonName'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      appointment['time'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment['address'] as String,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      appointment['status'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status'] as String,
                    style: TextStyle(
                      color: _getStatusColor(appointment['status']),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                _handleAppointmentAction(value, appointment);
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, size: 18),
                          SizedBox(width: 8),
                          Text('İptal Et'),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAppointmentsForDate(DateTime date) {
    // Bu fonksiyon gerçek projede veritabanından veri çekecek
    // Şimdilik örnek veriler döndürüyoruz
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return [
        {
          'id': '1',
          'salonName': 'Güzellik Salonu Merkez',
          'time': '14:30',
          'address': 'Merkez Mahallesi, Güzellik Caddesi No:15',
          'status': 'Onaylandı',
          'service': 'Saç Kesimi',
        },
        {
          'id': '2',
          'salonName': 'Elite Kuaför',
          'time': '16:00',
          'address': 'Elite Plaza, 2. Kat',
          'status': 'Beklemede',
          'service': 'Saç Boyama',
        },
      ];
    } else if (date.day == tomorrow.day &&
        date.month == tomorrow.month &&
        date.year == tomorrow.year) {
      return [
        {
          'id': '3',
          'salonName': 'Modern Saç Tasarım',
          'time': '10:00',
          'address': 'Modern Caddesi No:42',
          'status': 'Onaylandı',
          'service': 'Makyaj',
        },
      ];
    }

    return [];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Onaylandı':
        return Colors.green;
      case 'Beklemede':
        return Colors.orange;
      case 'İptal Edildi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleAppointmentAction(
    String action,
    Map<String, dynamic> appointment,
  ) {
    switch (action) {
      case 'edit':
        // Randevu düzenleme sayfasına yönlendirme
        print('Randevu düzenle: ${appointment['id']}');
        break;
      case 'cancel':
        // Randevu iptal etme dialog'u
        _showCancelDialog(appointment);
        break;
    }
  }

  void _showCancelDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Randevuyu İptal Et'),
            content: Text(
              '${appointment['salonName']} randevusunu iptal etmek istediğinizden emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  // Randevu iptal etme işlemi
                  print('Randevu iptal edildi: ${appointment['id']}');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Randevu iptal edildi')),
                  );
                },
                child: const Text('Evet, İptal Et'),
              ),
            ],
          ),
    );
  }
}
