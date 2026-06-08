class AnimationHelpers {
  static Duration staggeredDelay(int index, {int baseDelay = 100}) {
    return Duration(milliseconds: index * baseDelay);
  }
}
