class OptionItem {
  final String text;
  bool isChecked;

  OptionItem({
    required this.text,
    this.isChecked = false,
  });

  void toggle() {
    isChecked = !isChecked;
  }
}