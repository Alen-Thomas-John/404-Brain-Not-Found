import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For Date Formatting
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Setup',
      home: Scaffold(
        appBar: AppBar(title: Text('Firebase Initialized')),
        body: Center(child: Text('Firebase is Ready!')),
      ),
    );
  }
}
class AccommodationWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco-Friendly Accommodation',
      theme: ThemeData(primarySwatch: Colors.green),
      home: AccommodationPage(),
    );
  }
}

class AccommodationPage extends StatefulWidget {
  @override
  _AccommodationPageState createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  int ecoCoins = 200;
  List<Map<String, dynamic>> accommodations = [
    {
      'name': 'Green Leaf Resort',
      'location': 'New York, USA',
      'price': 120,
      'image': 'https://source.unsplash.com/400x300/?hotel,nature'
    },
    {
      'name': 'Solar Haven',
      'location': 'California, USA',
      'price': 95,
      'image': 'https://source.unsplash.com/400x300/?eco,hotel'
    },
  ];

  void _showBookingPopup(BuildContext context, Map<String, dynamic> hotel) {
    TextEditingController nightsController = TextEditingController(text: '1');
    DateTime? selectedDate;
    int nights = 1;
    int totalPrice = hotel['price'];

    void updateTotalPrice() {
      setState(() {
        totalPrice = hotel['price'] * nights;
      });
    }

    Future<void> _selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Book Your Stay'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Check-in Date',
                          hintText: selectedDate == null
                              ? 'Select Date'
                              : DateFormat.yMMMd().format(selectedDate!),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Number of Nights:"),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (nights > 1) {
                                setState(() {
                                  nights--;
                                  updateTotalPrice();
                                });
                              }
                            },
                          ),
                          Text('$nights'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                nights++;
                                updateTotalPrice();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total: \$${totalPrice}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Confirm Booking'),
                  onPressed: () {
                    setState(() {
                      ecoCoins += 10;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking Confirmed!')),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddHotelPopup(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('List Your Stay'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Hotel Name')),
              TextField(controller: locationController, decoration: InputDecoration(labelText: 'Location')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Price per Night')),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                setState(() {
                  accommodations.add({
                    'name': nameController.text,
                    'location': locationController.text,
                    'price': int.tryParse(priceController.text) ?? 0,
                    'image': 'https://source.unsplash.com/400x300/?hotel,eco'
                  });
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Accommodation Added!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eco-Friendly Accommodation'), actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ),
      ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accommodations.length,
              itemBuilder: (context, index) {
                final hotel = accommodations[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.network(hotel['image'], width: double.infinity, height: 200, fit: BoxFit.cover),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(hotel['name'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('📍 ${hotel['location']}'),
                            Text('💰 \$${hotel['price']} per night'),
                            SizedBox(height: 10),
                            ElevatedButton(
                              child: Text('Book Now'),
                              onPressed: () => _showBookingPopup(context, hotel),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Your Eco-Coins: $ecoCoins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('List Your Stay'),
              onPressed: () => _showAddHotelPopup(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Center(
        child: Text('Profile Page Coming Soon!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
