import 'package:documents_app/constants/screens.dart';
import 'package:documents_app/controllers/home_controller.dart';
import 'package:documents_app/controllers/navigation_controller.dart';
import 'package:documents_app/screens/search_screen/search_screen.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigationController = Get.put(NavigationController());
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: GlobalColors.background,
          appBar: AppBar(
            backgroundColor: GlobalColors.background,
            shadowColor: GlobalColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.account_circle,
                color: GlobalColors.blackIcon,
                size: 30,
              ),
              onPressed: () {
                navigationController
                    .onSelectBottomItemScreen(Screens.profileScreen);
              },
            ),
            title: Text(
              "${controller.firstName.value} ${controller.lastName.value}",
              style: TextStyle(color: GlobalColors.textColor),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  // Icons.notifications,
                  Icons.notifications_none,
                  color: GlobalColors.blackIcon,
                  size: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_outline,
                  color: GlobalColors.blackIcon,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     // padding: const EdgeInsets.all(8.0),
                //     // height: 140,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.red,
                //     ),
                //     child: Stack(children: [
                //       Image.asset(
                //         "./assets/images/banner_home_screen.jpg",
                //         fit: BoxFit.fill,
                //       )
                //     ]),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // width: 300,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "./assets/images/banner_home_screen.jpg",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          top: 10,
                          left: 10,
                          child: Text(
                            'CÙNG NHAU CHIA\n SẺ TÀI LIỆU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GlobalButton.buildButton(
                            context,
                            title: 'Chia sẻ',
                            btnColor: GlobalColors.appColor,
                            txtColor: Colors.white,
                            btnWidthRatio: 0.3,
                            btnHeight: 35,
                            onPress: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => {Get.to(SearchScreen())},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Expanded(child: Text('Tìm kiếm')),
                        ],
                      ),
                    ),
                  ),
                ),
                documentsList(title: "Được xem nhiều nhất", itemList: [
                  'Document 1',
                  'Document 2',
                  'Document 3',
                  'Document 4',
                  'Document 5',
                ]),
                documentsList(title: "Tài liệu mới", itemList: [
                  'Document 1',
                  'Document 2',
                  'Document 3',
                  'Document 4',
                  'Document 5',
                ]),
                documentsList(title: "Xem gần đây", itemList: [
                  'Document 1',
                  'Document 2',
                  'Document 3',
                  'Document 4',
                  'Document 5',
                ])
              ],
            ),
          ),
        );
      },
    );
  }

  documentsList({required String title, required List<String> itemList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.arrow_forward_ios_sharp),
            // )
            const Icon(Icons.arrow_forward_ios_sharp),
          ],
        ),
        SizedBox(
          height: 150, // Set the desired height of the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 120, // Set the desired width of each item
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Text(
                      itemList[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
