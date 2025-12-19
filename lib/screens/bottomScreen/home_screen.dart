import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hello,\nMr.Bhusan Shrestha',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 12),
                      Icon(Icons.search),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('View All', style: TextStyle(color: Colors.blue)),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  CategoryCard(icon: Icons.check_circle, title: 'Reports'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.local_pharmacy, title: 'Pharmacy'),
                ],
              ),

              const SizedBox(height: 24),

              // Doctors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Our doctors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('View All', style: TextStyle(color: Colors.blue)),
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: const [
                    AppointmentCard(
                      name: 'Dr.Babu Ram Bhattarai',
                      specialty: 'General Surgeon',
                      rating: 4.9,
                      time: '09:00 am - 02:00 pm',
                      image:'assets/images/doctor.jpg',
                      
                    ),
                    AppointmentCard(
                      name: 'Dr.Sanduk Ruit',
                      specialty: 'Eye Specialist',
                      rating: 4.8,
                      time: '10:00 am - 04:00 pm',
                      image:'assets/images/doctor2.jpg'

                    ),
                    AppointmentCard(
                      name: 'Ronaldo Shrestha',
                      specialty: 'Pharmacist',
                      rating: 3.6,
                      time: '10:00 am - 06:00 pm',
                      image:'assets/images/pharmacist.jpg'
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 36),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}



class AppointmentCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String time;
  final String image;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 28,
          // backgroundImage: AssetImage('assets/images'),
          backgroundImage: AssetImage('assets/images/doctor.jpg'), 
          backgroundColor: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        Text(rating.toString()),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(specialty, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(time),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Book now'),
          )
        ],
      ),
    );
  }
}
