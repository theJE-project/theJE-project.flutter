import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductDescriptionScreen(),
    );
  }
}


class ProductDescriptionScreen extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'image': 'assets/flower.jpg', // 첫 번째 강아지 상품 이미지
      'name': '귀여운 강아지 인형',
      'description': '이 강아지 인형은 부드럽고 귀여운 디자인으로, 어떤 공간에 두어도 잘 어울립니다.',
      'price': '\$20.00',
    },
    {
      'image': 'assets/flower.jpg', // 두 번째 강아지 상품 이미지
      'name': '애완용 강아지 인형',
      'description': '편안한 촉감으로, 애완용으로 완벽한 강아지 인형입니다.',
      'price': '\$25.00',
    },
    {
      'image': 'assets/flower.jpg', // 세 번째 강아지 상품 이미지
      'name': '작은 강아지 인형',
      'description': '작고 귀여운 강아지 인형으로 아이들에게 인기 있는 제품입니다.',
      'price': '\$15.00',
    },
    // 추가적인 상품을 여기에 더 추가할 수 있습니다.
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 설명'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(
            image: products[index]['image']!,
            name: products[index]['name']!,
            description: products[index]['description']!,
            price: products[index]['price']!,
          );
        },
      ),
    );
  }
}


class ProductItem extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;


  const ProductItem({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 (왼쪽)
              Image.asset(
                image,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 20), // 이미지와 텍스트 간의 간격


              // 텍스트 (오른쪽)
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상품 이름
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),


                    // 상품 설명
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),


                    // 가격
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
