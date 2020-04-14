getFormattedDate({DateTime date}) {
  assert(date != null);
  return _addToZero(date.day.toString()) +
      "." +
      _addToZero(date.month.toString()) +
      "." +
      date.year.toString();
}

String _addToZero(String num) {
  if (num.length == 1) return "0" + num;
  return num;
}
