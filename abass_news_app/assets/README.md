# Assets Directory

This directory contains all the images, icons, and other assets used in the Abass News app.

## Structure

```
assets/
├── icons/          # SVG icons for the app
│   ├── app_icon.svg
│   ├── news_icon.svg
│   ├── article_icon.svg
│   ├── issue_icon.svg
│   └── user_icon.svg
└── images/         # PNG/JPG images
    ├── logo.png
    ├── placeholder_article.png
    └── placeholder_issue.png
```

## Usage

### Icons
- **app_icon.svg**: Main app icon used in splash screen and app launcher
- **news_icon.svg**: Icon for news-related features
- **article_icon.svg**: Icon for article management
- **issue_icon.svg**: Icon for issue/bug reporting
- **user_icon.svg**: Icon for user-related features

### Images
- **logo.png**: App logo (placeholder - replace with actual logo)
- **placeholder_article.png**: Default image for articles without images
- **placeholder_issue.png**: Default image for issues without images

## Adding New Assets

1. **Icons**: Add SVG files to `icons/` directory
2. **Images**: Add PNG/JPG files to `images/` directory
3. **Update pubspec.yaml**: Assets are automatically included via wildcard patterns
4. **Use in code**: Import via `AppImages` constants

## Image Guidelines

- **Icons**: Use SVG format for scalability
- **Images**: Use PNG for transparency, JPG for photos
- **Sizes**: Optimize for mobile (max 1024px width)
- **File size**: Keep under 1MB for performance

## Code Usage

```dart
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_images.dart';

// Using SVG icons
SvgPicture.asset(AppImages.newsIcon)

// Using network images with caching
CachedNetworkImage(
  imageUrl: article.imageUrl ?? AppImages.defaultArticleImage,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
``` 