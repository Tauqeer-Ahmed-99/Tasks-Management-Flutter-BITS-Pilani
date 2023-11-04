import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            builder: Container(
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.25,
            child: Column(
              children: [
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SkeletonLoader(
            builder: Container(
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.25,
            child: Column(
              children: [
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SkeletonLoader(
            builder: Container(
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.25,
            child: Column(
              children: [
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SkeletonLoader(
                  builder: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
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
