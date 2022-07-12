import 'dart:async';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/colors.dart';
import 'package:snagom_app/pages/search/searchController.dart';
import 'package:snagom_app/widgets/searchPersonCard.dart';
import 'package:snagom_app/widgets/searchTagCard.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  SearchController searchController = Get.put(SearchController());
  TabController _tabController;
  bool changed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    _tabController.addListener(() {
      searchController.searchResult.value = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScaffoldColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Theme(
            data: ThemeData(
              primarySwatch: Colors.green,
            ),
            child: TextField(
              onChanged: (value) {
                // Timer(const Duration(seconds: 1), () {
                //   if (changed) {
                //     if (_tabController.index == 0) {
                //       searchController.searchUser(value);
                //     } else if (_tabController.index == 1) {
                //       searchController.searchTag(value, 'media');
                //     } else {
                //       searchController.searchTag(value, 'text');
                //     }
                //   }
                //   changed = false;
                // });
                if (_tabController.index == 0) {
                  searchController.searchUser(value);
                } else if (_tabController.index == 1) {
                  searchController.searchTag(value, 'media');
                } else {
                  searchController.searchTag(value, 'text');
                }
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                    left: 12,
                    top: 12,
                    right: 12,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/searchIcon.svg',
                    height: 10,
                    width: 10,
                  ),
                ),
                hintText: '',
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          ButtonsTabBar(
            controller: _tabController,
            height: 40,
            contentPadding: EdgeInsets.all(0),
            buttonMargin: EdgeInsets.all(0),
            radius: 0,
            backgroundColor: Colors.grey[300],
            unselectedBackgroundColor: Color(0xfff6f6f6),
            unselectedLabelStyle: TextStyle(color: Colors.black),
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                child: Container(
                  width: Get.width / 3,
                  child: SvgPicture.asset(
                    'assets/icons/personIcon.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: Get.width / 3,
                  child: SvgPicture.asset(
                    'assets/icons/mediaIcon.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: Get.width / 3,
                  child: SvgPicture.asset(
                    'assets/icons/textIcon.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Obx(
                  () => searchController.resultsLoading.value
                      ? Container()
                      : Container(
                          height: 1000,
                          child: ListView.builder(
                            itemCount:
                                searchController.searchResult.value.length,
                            itemBuilder: (context, index) {
                              return SearchPersonCard(
                                  searchController.searchResult.value[index]);
                            },
                          ),
                        ),
                ),
                Obx(
                  () => searchController.resultsLoading.value
                      ? Container()
                      : Container(
                          height: 1000,
                          child: ListView.builder(
                            itemCount:
                                searchController.searchResult.value.length,
                            itemBuilder: (context, index) {
                              return SearchTagCard(
                                  searchController.searchResult.value[index]);
                            },
                          ),
                        ),
                ),
                Obx(
                  () => searchController.resultsLoading.value
                      ? Container()
                      : Container(
                          height: 1000,
                          child: ListView.builder(
                            itemCount:
                                searchController.searchResult.value.length,
                            itemBuilder: (context, index) {
                              return SearchTagCard(
                                  searchController.searchResult.value[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
