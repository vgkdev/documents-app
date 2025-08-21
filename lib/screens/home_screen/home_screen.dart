import 'package:documents_app/constants/screens.dart';
import 'package:documents_app/controllers/home_controller.dart';
import 'package:documents_app/controllers/navigation_controller.dart';
import 'package:documents_app/screens/search_screen/search_screen.dart';
import 'package:documents_app/widgets/document_card.dart';
import 'package:documents_app/themes/global_button.dart';
import 'package:documents_app/themes/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:documents_app/utils/firebase_test.dart';

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
              // IconButton(
              //   icon: Icon(
              //     Icons.bug_report,
              //     color: GlobalColors.blackIcon,
              //     size: 30,
              //   ),
              //   onPressed: () {
              //     controller.debugStatus();
              //     Get.snackbar(
              //       'Debug Info',
              //       'Check console for debug information',
              //       snackPosition: SnackPosition.TOP,
              //       duration: Duration(seconds: 2),
              //     );
              //   },
              // ),
              IconButton(
                icon: Icon(
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
              IconButton(
                icon: Icon(
                  Icons.cloud_upload,
                  color: GlobalColors.blackIcon,
                  size: 30,
                ),
                onPressed: () {
                  FirebaseTest.testFirebaseConnection();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.refreshDocuments(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Banner section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                              onPress: () {
                                // Chuyển đến màn hình documents để xem tất cả
                                navigationController.onSelectBottomItemScreen(
                                    Screens.documentsScreen);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Search bar
                  GestureDetector(
                    onTap: () => {Get.to(SearchScreen())},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
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

                  // Loading indicator
                  if (controller.isLoadingDocuments.value)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // Error message
                  if (controller.documentsError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.documentsError.value,
                                style: TextStyle(color: Colors.red[800]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Debug Info (chỉ hiển thị trong debug mode)
                  // if (kDebugMode)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(12),
                  //       decoration: BoxDecoration(
                  //         color: Colors.blue[100],
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(color: Colors.blue[300]!),
                  //       ),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Icon(Icons.bug_report, color: Colors.blue[700]),
                  //               SizedBox(width: 8),
                  //               Text(
                  //                 'Debug Info',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.blue[700],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           SizedBox(height: 8),
                  //           Text(
                  //               'Loading: ${controller.isLoadingDocuments.value}'),
                  //           Text('Error: ${controller.documentsError.value}'),
                  //           Text('New Docs: ${controller.newDocuments.length}'),
                  //           Text(
                  //               'Recent Docs: ${controller.recentDocuments.length}'),
                  //           Text(
                  //               'Popular Docs: ${controller.popularDocuments.length}'),
                  //           Text(
                  //               'Total: ${controller.newDocuments.length + controller.recentDocuments.length + controller.popularDocuments.length}'),
                  //         ],
                  //       ),
                  //     ),
                  //   ),

                  // Documents sections
                  if (!controller.isLoadingDocuments.value)
                    Column(
                      children: [
                        // Tài liệu mới
                        if (controller.newDocuments.isNotEmpty)
                          documentsList(
                            title: "Tài liệu mới",
                            documents: controller.newDocuments,
                          ),

                        // Tài liệu xem gần đây
                        if (controller.recentDocuments.isNotEmpty)
                          documentsList(
                            title: "Xem gần đây",
                            documents: controller.recentDocuments,
                          ),

                        // Tài liệu phổ biến
                        if (controller.popularDocuments.isNotEmpty)
                          documentsList(
                            title: "Được xem nhiều nhất",
                            documents: controller.popularDocuments,
                          ),

                        // Thông báo khi không có tài liệu
                        if (controller.newDocuments.isEmpty &&
                            controller.recentDocuments.isEmpty &&
                            controller.popularDocuments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Chưa có tài liệu nào',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Hãy chia sẻ tài liệu đầu tiên của bạn!',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget documentsList({
    required String title,
    required List<Reference> documents,
  }) {
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
            const Icon(Icons.arrow_forward_ios_sharp),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DocumentCard(
                  documentRef: documents[index],
                  width: 120,
                  height: 150,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
