import '../models/models.dart';

class MockData {
  static final List<Product> products = [
    Product(id:'p1',name:'Organic Avocados',description:'Fresh Kenyan avocados, hand-picked at peak ripeness. Rich in healthy fats and nutrients.',price:4500,originalPrice:5500,category:'Fruits',unit:'Pack of 3',emoji:'🥑',rating:4.8,reviews:312,stock:45,badge:'Bestseller'),
    Product(id:'p2',name:'Wild Tilapia Fillet',description:'Freshly caught Lake Victoria tilapia. Cleaned and filleted daily.',price:12000,category:'Seafood',unit:'Per kg',emoji:'🐟',rating:4.9,reviews:189,stock:20,badge:'Fresh Today'),
    Product(id:'p3',name:'Sourdough Loaf',description:'Artisan sourdough baked fresh every morning. Crispy crust, soft interior.',price:3500,category:'Bakery',unit:'800g loaf',emoji:'🍞',rating:4.7,reviews:421,stock:15,badge:"Today's Bake"),
    Product(id:'p4',name:'Fresh Mango',description:'Sweet Alphonso mangoes from coastal farms. Naturally ripened.',price:2000,originalPrice:2800,category:'Fruits',unit:'Per kg',emoji:'🥭',rating:4.6,reviews:256,stock:80,badge:'Sale'),
    Product(id:'p5',name:'Cherry Tomatoes',description:'Vine-ripened cherry tomatoes bursting with sweetness.',price:1800,category:'Vegetables',unit:'250g punnet',emoji:'🍅',rating:4.5,reviews:178,stock:60,badge:'Organic'),
    Product(id:'p6',name:'Free-Range Eggs',description:'Eggs from free-range hens raised on natural feed. Rich golden yolks.',price:4200,category:'Dairy & Eggs',unit:'Dozen',emoji:'🥚',rating:4.9,reviews:534,stock:100,badge:'Free-Range'),
    Product(id:'p7',name:'Fresh Spinach',description:'Locally grown baby spinach. Washed and ready to cook.',price:1200,category:'Vegetables',unit:'500g bag',emoji:'🥬',rating:4.4,reviews:203,stock:40,badge:'Farm Fresh'),
    Product(id:'p8',name:'Watermelon',description:'Sweet, juicy watermelon from Kilosa farms.',price:3000,category:'Fruits',unit:'Per piece',emoji:'🍉',rating:4.8,reviews:167,stock:30,badge:'Sweet'),
    Product(id:'p9',name:'Whole Milk',description:'Fresh full-cream milk from local dairy farms. Pasteurised daily.',price:2500,category:'Dairy & Eggs',unit:'1 litre',emoji:'🥛',rating:4.7,reviews:389,stock:75,badge:'Daily Fresh'),
    Product(id:'p10',name:'Sweet Potato',description:'Organic orange-fleshed sweet potatoes from highland farms.',price:1500,category:'Vegetables',unit:'Per kg',emoji:'🍠',rating:4.3,reviews:145,stock:90,badge:'Organic'),
    Product(id:'p11',name:'Pilipili (Chilli)',description:'Fresh hot chillies. Adds the perfect kick to your dishes.',price:800,category:'Spices',unit:'100g pack',emoji:'🌶️',rating:4.6,reviews:98,stock:120,badge:'Hot!'),
    Product(id:'p12',name:'Coconut Oil',description:'Cold-pressed virgin coconut oil from Zanzibar coconuts.',price:8500,category:'Pantry',unit:'500ml',emoji:'🥥',rating:4.8,reviews:211,stock:50,badge:'Pure'),
    Product(id:'p13',name:'Ugali Flour',description:'Premium white maize flour milled from selected maize.',price:3200,category:'Pantry',unit:'2kg pack',emoji:'🌽',rating:4.5,reviews:678,stock:200,badge:'Popular'),
    Product(id:'p14',name:'Chicken Breast',description:'Fresh boneless skinless chicken breast. Halal certified.',price:9500,category:'Meat',unit:'Per kg',emoji:'🍗',rating:4.7,reviews:342,stock:35,badge:'Halal'),
    Product(id:'p15',name:'Pineapple',description:'Sweet and tangy pineapples from Kibaha farms.',price:3500,category:'Fruits',unit:'Per piece',emoji:'🍍',rating:4.6,reviews:189,stock:25,badge:'Tropical'),
    Product(id:'p16',name:'Garlic',description:'Fresh garlic bulbs. Essential for East African cooking.',price:1000,category:'Vegetables',unit:'250g',emoji:'🧄',rating:4.7,reviews:412,stock:150,badge:'Fresh'),
  ];

  static final List<String> categories = [
    'All', 'Fruits', 'Vegetables', 'Meat', 'Seafood',
    'Dairy & Eggs', 'Bakery', 'Pantry', 'Spices',
  ];

  static final List<AppUser> customers = [
    AppUser(id:'u1',name:'Amina Hassan',email:'amina@example.com',phone:'+255712345678',address:'Kinondoni, Dar es Salaam',totalSpent:145000,totalOrders:12,joinedAt:DateTime(2024,1,15)),
    AppUser(id:'u2',name:'John Mbeki',email:'john@example.com',phone:'+255722345679',address:'Ilala, Dar es Salaam',totalSpent:87500,totalOrders:7,joinedAt:DateTime(2024,2,20)),
    AppUser(id:'u3',name:'Fatuma Ally',email:'fatuma@example.com',phone:'+255733345680',address:'Temeke, Dar es Salaam',totalSpent:234000,totalOrders:19,joinedAt:DateTime(2023,11,5)),
    AppUser(id:'u4',name:'Peter Nkomo',email:'peter@example.com',phone:'+255744345681',address:'Ubungo, Dar es Salaam',totalSpent:56000,totalOrders:4,joinedAt:DateTime(2024,3,10)),
    AppUser(id:'u5',name:'Mariam Said',email:'mariam@example.com',phone:'+255755345682',address:'Kariakoo, Dar es Salaam',totalSpent:312000,totalOrders:28,joinedAt:DateTime(2023,9,1)),
  ];

  static List<AppOrder> generateOrders() {
    final now = DateTime.now();
    return [
      AppOrder(id:'ORD-001',userId:'u1',userName:'Amina Hassan',userPhone:'+255712345678',
        items:[OrderItem(product:products[0],quantity:2,price:4500),OrderItem(product:products[5],quantity:1,price:4200)],
        subtotal:13200,deliveryFee:2000,total:15200,deliveryAddress:'Kinondoni, DSM',
        paymentMethod:'M-Pesa',status:OrderStatus.delivered,createdAt:now.subtract(const Duration(days:2))),
      AppOrder(id:'ORD-002',userId:'u2',userName:'John Mbeki',userPhone:'+255722345679',
        items:[OrderItem(product:products[1],quantity:1,price:12000),OrderItem(product:products[2],quantity:2,price:3500)],
        subtotal:19000,deliveryFee:2000,total:21000,deliveryAddress:'Ilala, DSM',
        paymentMethod:'Cash on Delivery',status:OrderStatus.outForDelivery,createdAt:now.subtract(const Duration(hours:5))),
      AppOrder(id:'ORD-003',userId:'u3',userName:'Fatuma Ally',userPhone:'+255733345680',
        items:[OrderItem(product:products[3],quantity:3,price:2000),OrderItem(product:products[6],quantity:2,price:1200)],
        subtotal:8400,deliveryFee:0,total:8400,deliveryAddress:'Temeke, DSM',
        paymentMethod:'Airtel Money',status:OrderStatus.preparing,createdAt:now.subtract(const Duration(hours:2))),
      AppOrder(id:'ORD-004',userId:'u4',userName:'Peter Nkomo',userPhone:'+255744345681',
        items:[OrderItem(product:products[12],quantity:2,price:3200),OrderItem(product:products[8],quantity:3,price:2500)],
        subtotal:13900,deliveryFee:2000,total:15900,deliveryAddress:'Ubungo, DSM',
        paymentMethod:'M-Pesa',status:OrderStatus.confirmed,createdAt:now.subtract(const Duration(hours:1))),
      AppOrder(id:'ORD-005',userId:'u5',userName:'Mariam Said',userPhone:'+255755345682',
        items:[OrderItem(product:products[13],quantity:2,price:9500),OrderItem(product:products[5],quantity:3,price:4200)],
        subtotal:31600,deliveryFee:2000,total:33600,deliveryAddress:'Kariakoo, DSM',
        paymentMethod:'Cash on Delivery',status:OrderStatus.pending,createdAt:now.subtract(const Duration(minutes:30))),
    ];
  }

  static List<AppNotification> notifications = [
    AppNotification(id:'n1',title:'Order Confirmed!',message:'Your order ORD-001 has been confirmed and is being prepared.',type:'order',createdAt:DateTime.now().subtract(const Duration(hours:1))),
    AppNotification(id:'n2',title:'Weekend Sale 🎉',message:'50% off on all fruits this weekend! Use code TWENDEFRESH.',type:'promo',createdAt:DateTime.now().subtract(const Duration(hours:3))),
    AppNotification(id:'n3',title:'Order Delivered',message:'Your order ORD-002 has been delivered. Enjoy your fresh produce!',type:'order',isRead:true,createdAt:DateTime.now().subtract(const Duration(days:1))),
  ];

  static List<Review> reviews = [
    Review(id:'r1',userId:'u1',userName:'Amina H.',productId:'p1',rating:5,comment:'Very fresh and delicious avocados! Will order again.',createdAt:DateTime.now().subtract(const Duration(days:3))),
    Review(id:'r2',userId:'u2',userName:'John M.',productId:'p1',rating:4,comment:'Good quality, delivered on time.',createdAt:DateTime.now().subtract(const Duration(days:5))),
    Review(id:'r3',userId:'u3',userName:'Fatuma A.',productId:'p2',rating:5,comment:'The tilapia was incredibly fresh. Best I have had!',createdAt:DateTime.now().subtract(const Duration(days:2))),
  ];
}