# My Code Snippets Repository

Welcome to my repository of reusable code snippets! Here, I will document various code blocks that I frequently use in my projects.

## Flutter MaterialApp Scroll Behavior

This code snippet demonstrates how to customize the scroll behavior in a Flutter `MaterialApp`. It allows scrolling with different types of input devices such as mouse, touch, and stylus (simply how to make web scrollable).

### Code Snippet

```dart
MaterialApp(
  scrollBehavior: const MaterialScrollBehavior().copyWith(
    dragDevices: {
      PointerDeviceKind.mouse,
      PointerDeviceKind.touch,
      PointerDeviceKind.stylus,
      PointerDeviceKind.unknown,
    },
  ),
)
