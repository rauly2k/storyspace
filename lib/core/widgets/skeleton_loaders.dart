import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

/// Story card skeleton loader
class StoryCardSkeleton extends StatelessWidget {
  const StoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            const AspectRatio(
              aspectRatio: 16 / 9,
              child: SkeletonBox(borderRadius: 0),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const SkeletonLine(width: double.infinity),
                  const SizedBox(height: 8),
                  // Subtitle
                  SkeletonLine(width: MediaQuery.of(context).size.width * 0.6),
                  const SizedBox(height: 12),
                  // Metadata row
                  const Row(
                    children: [
                      SkeletonCircle(size: 20),
                      SizedBox(width: 8),
                      SkeletonLine(width: 60, height: 10),
                      Spacer(),
                      SkeletonLine(width: 40, height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kid profile card skeleton loader
class ProfileCardSkeleton extends StatelessWidget {
  const ProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              const SkeletonCircle(size: 80),
              const SizedBox(height: 16),
              // Name
              const SkeletonLine(width: 100),
              const SizedBox(height: 8),
              // Age
              const SkeletonLine(width: 60, height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// List item skeleton loader
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Leading icon/image
            const SkeletonCircle(size: 48),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: double.infinity),
                  const SizedBox(height: 8),
                  SkeletonLine(width: MediaQuery.of(context).size.width * 0.5),
                ],
              ),
            ),
            // Trailing
            const SizedBox(width: 16),
            const SkeletonBox(width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}

/// Generic grid skeleton loader
class GridSkeleton extends StatelessWidget {
  const GridSkeleton({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
  });

  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: const Card(
            elevation: 2,
            child: Center(
              child: SkeletonBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Generic list skeleton loader
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    super.key,
    required this.itemCount,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const ListItemSkeleton(),
    );
  }
}

/// Page header skeleton
class PageHeaderSkeleton extends StatelessWidget {
  const PageHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonLine(width: 200, height: 28),
            const SizedBox(height: 8),
            SkeletonLine(width: MediaQuery.of(context).size.width * 0.7),
          ],
        ),
      ),
    );
  }
}

/// Form skeleton loader
class FormSkeleton extends StatelessWidget {
  const FormSkeleton({
    super.key,
    this.fieldCount = 3,
  });

  final int fieldCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            fieldCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(width: 100, height: 14),
                  const SizedBox(height: 8),
                  const SkeletonBox(
                    width: double.infinity,
                    height: 56,
                    borderRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
