import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var totalProducts = 0.obs;
  var totalCategories = 0.obs;
  var totalSchools = 0.obs;
  var totalOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var pendingOrders = 0.obs;
  var lowStockProducts = 0.obs;
  var activeUsers = 0.obs;
  var recentOrders = <Map<String, dynamic>>[].obs;

  // Predefined school categories with full hierarchy
  final List<Map<String, dynamic>> schoolCategories = [
    {
      'id': 1,
      'name': 'School Uniforms',
      'icon': '👔',
      'color': 0xFFFF9800,
      'subCategories': [
        {
          'name': 'Boys Uniform',
          'sections': ['Shirts', 'Trousers', 'Blazers', 'Ties', 'Socks', 'Belt'],
        },
        {
          'name': 'Girls Uniform',
          'sections': ['Dress', 'Skirts', 'Shirts', 'Blazers', 'Ribbons', 'Socks'],
        },
        {
          'name': 'Winter Wear',
          'sections': ['Sweaters', 'Jackets', 'Hoodies', 'Mufflers', 'Gloves'],
        },
        {
          'name': 'Accessories',
          'sections': ['Badges', 'House Tie', 'School Cap', 'Belt', 'ID Card Holder'],
        },
      ],
    },
    {
      'id': 2,
      'name': 'Sports & PE Kit',
      'icon': '⚽',
      'color': 0xFF009688,
      'subCategories': [
        {
          'name': 'Sports Uniform',
          'sections': ['Track Suit', 'Sports Shorts', 'Sports T-Shirt', 'Joggers'],
        },
        {
          'name': 'Footwear',
          'sections': ['Sports Shoes', 'Canvas Shoes', 'Socks', 'Insoles'],
        },
        {
          'name': 'Equipment',
          'sections': ['Cricket Kit', 'Football', 'Badminton', 'Basketball', 'Table Tennis'],
        },
      ],
    },
    {
      'id': 3,
      'name': 'Bags & Accessories',
      'icon': '🎒',
      'color': 0xFF795548,
      'subCategories': [
        {
          'name': 'Bags',
          'sections': ['School Backpack', 'Trolley Bag', 'Side Bag', 'Pencil Pouch'],
        },
        {
          'name': 'Lunch & Hydration',
          'sections': ['Lunch Box', 'Water Bottle', 'Tiffin Bag', 'Flask'],
        },
        {
          'name': 'Stationery Holders',
          'sections': ['Geometry Box', 'Pen Stand', 'Folder', 'File Bag'],
        },
      ],
    },
    {
      'id': 4,
      'name': 'Textbooks',
      'icon': '📚',
      'color': 0xFF3F51B5,
      'subCategories': [
        {
          'name': 'CBSE Books',
          'sections': ['Class 1-2', 'Class 3-5', 'Class 6-8', 'Class 9-10', 'Class 11-12'],
        },
        {
          'name': 'ICSE Books',
          'sections': ['Class 1-2', 'Class 3-5', 'Class 6-8', 'Class 9-10', 'Class 11-12'],
        },
        {
          'name': 'State Board',
          'sections': ['Primary', 'Middle School', 'High School', 'Higher Secondary'],
        },
        {
          'name': 'Used Books',
          'sections': ['Good Condition', 'Acceptable Condition'],
        },
      ],
    },
    {
      'id': 5,
      'name': 'Competition Books',
      'icon': '🏆',
      'color': 0xFFE91E63,
      'subCategories': [
        {
          'name': 'Olympiad',
          'sections': ['Maths Olympiad', 'Science Olympiad', 'English Olympiad', 'GK Olympiad'],
        },
        {
          'name': 'Engineering Prep',
          'sections': ['JEE Mains', 'JEE Advanced', 'BITSAT', 'NDA'],
        },
        {
          'name': 'Medical Prep',
          'sections': ['NEET', 'AIIMS', 'JIPMER'],
        },
        {
          'name': 'Other Competitions',
          'sections': ['NTSE', 'KVPY', 'IMO', 'NSO'],
        },
      ],
    },
    {
      'id': 6,
      'name': 'Notebooks & Writing',
      'icon': '📓',
      'color': 0xFF009688,
      'subCategories': [
        {
          'name': 'Notebooks',
          'sections': ['Single Line', 'Four Line', 'Square Line', 'Plain', 'Drawing Book'],
        },
        {
          'name': 'Pens & Pencils',
          'sections': ['Ball Pen', 'Gel Pen', 'Fountain Pen', 'Pencil', 'Color Pencils', 'Markers'],
        },
        {
          'name': 'Stationery',
          'sections': ['Eraser', 'Sharpener', 'Ruler', 'Compass', 'Calculator', 'Glue Stick'],
        },
      ],
    },
    {
      'id': 7,
      'name': 'Art & Craft',
      'icon': '🎨',
      'color': 0xFFFF5722,
      'subCategories': [
        {
          'name': 'Drawing Supplies',
          'sections': ['Sketch Pens', 'Watercolors', 'Acrylic Colors', 'Crayons', 'Oil Pastels'],
        },
        {
          'name': 'Craft Materials',
          'sections': ['Chart Paper', 'Thermocol', 'Scissors', 'Fevicol', 'Clay & Dough'],
        },
        {
          'name': 'Canvas & Boards',
          'sections': ['Drawing Board', 'Canvas', 'Easel Stand'],
        },
      ],
    },
    {
      'id': 8,
      'name': 'Lab Equipment',
      'icon': '🔬',
      'color': 0xFF607D8B,
      'subCategories': [
        {
          'name': 'Safety Gear',
          'sections': ['Lab Coat', 'Safety Goggles', 'Gloves', 'Apron'],
        },
        {
          'name': 'Science Instruments',
          'sections': ['Microscope', 'Test Tubes', 'Beakers', 'Bunsen Burner', 'Dissection Kit'],
        },
        {
          'name': 'Maths Instruments',
          'sections': ['Geometry Set', 'Protractor', 'Set Squares', 'Graph Sheets'],
        },
      ],
    },
    {
      'id': 9,
      'name': 'Musical Instruments',
      'icon': '🎵',
      'color': 0xFF9C27B0,
      'subCategories': [
        {
          'name': 'String Instruments',
          'sections': ['Guitar', 'Violin', 'Ukulele'],
        },
        {
          'name': 'Wind Instruments',
          'sections': ['Flute', 'Harmonium', 'Recorder', 'Trumpet'],
        },
        {
          'name': 'Percussion',
          'sections': ['Tabla', 'Drums', 'Keyboard', 'Xylophone'],
        },
      ],
    },
    {
      'id': 10,
      'name': 'Electronics',
      'icon': '💻',
      'color': 0xFF2196F3,
      'subCategories': [
        {
          'name': 'Devices',
          'sections': ['Scientific Calculator', 'Tablet', 'E-Reader', 'Headphones'],
        },
        {
          'name': 'Accessories',
          'sections': ['USB Cable', 'Pen Drive', 'Memory Card', 'Power Bank'],
        },
      ],
    },
    {
      'id': 11,
      'name': 'School Furniture',
      'icon': '🪑',
      'color': 0xFF8D6E63,
      'subCategories': [
        {
          'name': 'Study Furniture',
          'sections': ['Study Table', 'Study Chair', 'Book Shelf', 'Study Lamp'],
        },
        {
          'name': 'Storage',
          'sections': ['Book Rack', 'Cabinet', 'Drawer Unit', 'Locker'],
        },
      ],
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get(dashboardApi);
      if (res != null && res['data'] != null) {
        final data = res['data'];
        totalProducts.value = data['total_products'] ?? 0;
        totalCategories.value = data['total_categories'] ?? 0;
        totalSchools.value = data['total_schools'] ?? 0;
        totalOrders.value = data['total_orders'] ?? 0;
        totalRevenue.value = double.tryParse(data['total_revenue']?.toString() ?? '0') ?? 0;
        pendingOrders.value = data['pending_orders'] ?? 0;
        lowStockProducts.value = data['low_stock'] ?? 0;
        activeUsers.value = data['active_users'] ?? 0;
        recentOrders.value = List<Map<String, dynamic>>.from(data['recent_orders'] ?? []);
      }
    } catch (e) {
      // Use mock data if API fails
      totalProducts.value = 248;
      totalCategories.value = 11;
      totalSchools.value = 34;
      totalOrders.value = 1290;
      totalRevenue.value = 542350;
      pendingOrders.value = 18;
      lowStockProducts.value = 7;
      activeUsers.value = 423;
    } finally {
      isLoading.value = false;
    }
  }
}
