import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:snagom_app/globals/urls.dart';
import 'package:snagom_app/pages/tags/tagDetail.dart';

class SearchTagCard extends StatelessWidget {
  var json;
  SearchTagCard(this.json);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          onTap: () {
            Get.to(TagDetail(json['id'], json['name'], json['storyCount'],
                json['type'].toString()));
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/icons/logo.svg'),
          ),
          title: Text(
            '#' + json['name'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            json['storyCount'].toString() + '  contents',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
