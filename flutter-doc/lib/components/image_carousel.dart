import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'images/pangolin.jpeg',
      'images/panda.jpeg',
       'images/birds.jpeg',
       'images/intro_picture.jpeg',
      'images/fish.jpeg',
       'images/frog.jpeg',
      'images/leopard.jpeg',
       'images/insect.jpeg',
      'images/tiger.jpeg',
      'images/whale.jpeg',


    ];

    return Center(
      child: CarouselSlider.builder(
        itemCount: imgList.length,
        itemBuilder: (context, index, realIndex) {
          final imgUrl = imgList[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imgUrl,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 400.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
         autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
      ),
    );
  }
}
