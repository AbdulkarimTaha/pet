import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomListView extends StatelessWidget {
  final String usernamedb;
  final String textPost;
  final String? image1;
  final String? image2;
  final String? image3;

  const CustomListView({
    super.key,
    required this.usernamedb,
    required this.textPost,
    this.image1,
    this.image2,
    this.image3,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hasImages = image1 != null || image2 != null || image3 != null;
    final images = [image1, image2, image3].where((img) => img != null).toList();

    return Container(
      constraints: BoxConstraints(
        minHeight: hasImages ? size.height * 0.42 : size.height * 0.15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xffD9DEDF),
                  ),
                  child: Icon(
                    Icons.person,
                    size: size.width * 0.06,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usernamedb,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: size.width * 0.035,
                          fontFamily: 'poppins2',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.69,
                        ),
                      ),
                      Text(
                        textPost,
                        style: TextStyle(
                          color: const Color(0xFF222222),
                          fontSize: size.width * 0.035,
                          fontFamily: 'poppins1',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.69,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  size: size.width * 0.06,
                ),
              ],
            ),
          ),
          if (hasImages)
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: images.map((imageUrl) {
                    return Container(
                      margin: EdgeInsets.only(right: size.width * 0.02),
                      width: size.width * 0.5,
                      height: size.height * 0.3,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.15),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/favorite.svg',
                    width: size.width * 0.06,
                    height: size.width * 0.06,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/comment.svg',
                    width: size.width * 0.055,
                    height: size.width * 0.055,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: size.width,
            color: const Color(0xffD9D9D9),
          ),
        ],
      ),
    );
  }
}
