import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiffin Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

// Global cart list to store selected food items
List<Map<String, String>> cart = [];
String? selectedMess; // To keep track of the selected mess

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login as', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerHomePage()),
                  );
                },
                child: Text('Customer'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Mess Owner page
                },
                child: Text('Mess Owner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  List<Map<String, String>> messes = [
    {"messName": "Mess 1", "location": "Location 1", "price": "₹100"},
    {"messName": "Mess 2", "location": "Location 2", "price": "₹120"},
    {"messName": "Mess 3", "location": "Location 3", "price": "₹150"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiffin Delivery'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search mess',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            // Mess cards
            Expanded(
              child: ListView(
                children: messes
                    .where((mess) => mess["messName"]!.toLowerCase().contains(searchQuery))
                    .map((mess) => MessCard(
                  messName: mess["messName"]!,
                  location: mess["location"]!,
                  price: mess["price"]!,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessCard extends StatelessWidget {
  final String messName;
  final String location;
  final String price;

  MessCard({required this.messName, required this.location, required this.price});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selectedMess == null || selectedMess == messName) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessDetailsPage(messName: messName, location: location),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can only add items from one mess per transaction.'),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(location, style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
                price,
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessDetailsPage extends StatefulWidget {
  final String messName;
  final String location;

  MessDetailsPage({required this.messName, required this.location});

  @override
  _MessDetailsPageState createState() => _MessDetailsPageState();
}

class _MessDetailsPageState extends State<MessDetailsPage> {
  final List<Map<String, String>> foodOptions = [
    {"name": "Paneer Curry", "price": "₹150"},
    {"name": "Chicken Biryani", "price": "₹180"},
    {"name": "Vegetable Thali", "price": "₹120"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.messName} - Food Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.messName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(widget.location, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Text("Food Options:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: foodOptions.length,
                itemBuilder: (context, index) {
                  final food = foodOptions[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: ListTile(
                      title: Text(food["name"]!, style: TextStyle(fontSize: 18)),
                      trailing: Text(food["price"]!, style: TextStyle(fontSize: 18, color: Colors.green)),
                      onTap: () {
                        // Add food to cart only if from the same mess or no mess selected yet
                        if (selectedMess == null || selectedMess == widget.messName) {
                          setState(() {
                            selectedMess = widget.messName;
                            cart.add(food);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${food["name"]} added to cart')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You can only add items from one mess at a time.')),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    setState(() {
      totalPrice = cart.fold(0, (sum, item) => sum + int.parse(item['price']!.substring(1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Items in Cart:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final food = cart[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: ListTile(
                      title: Text(food["name"]!, style: TextStyle(fontSize: 18)),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            cart.removeAt(index);
                            calculateTotal();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: ₹$totalPrice',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cart.isEmpty
                  ? null
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully!')),
                );
                setState(() {
                  cart.clear();
                  selectedMess = null;
                });
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

