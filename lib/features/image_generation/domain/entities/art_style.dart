/// Available art styles for story images
enum ArtStyle {
  cartoon('Cartoon', 'Bright, colorful cartoon style'),
  storybook('Storybook', 'Classic children\'s book illustration'),
  threeD('3D', 'Modern 3D rendered style'),
  anime('Anime', 'Japanese anime/manga style');

  final String label;
  final String description;

  const ArtStyle(this.label, this.description);

  /// Get icon representation for the art style
  String get iconEmoji {
    switch (this) {
      case ArtStyle.cartoon:
        return '🎨';
      case ArtStyle.storybook:
        return '📚';
      case ArtStyle.threeD:
        return '🎬';
      case ArtStyle.anime:
        return '🌸';
    }
  }

  /// Convert to API-friendly string for prompts
  String toPromptStyle() {
    switch (this) {
      case ArtStyle.cartoon:
        return 'colorful cartoon illustration style, bright colors, playful';
      case ArtStyle.storybook:
        return 'classic storybook illustration, watercolor style, warm tones';
      case ArtStyle.threeD:
        return '3D rendered illustration, Pixar-style, vibrant and modern';
      case ArtStyle.anime:
        return 'anime illustration style, manga-inspired, expressive';
    }
  }

  /// Check if available for free tier
  bool get isFreeStyle => this == ArtStyle.cartoon;

  /// Check if requires Premium
  bool get requiresPremium => !isFreeStyle;
}
