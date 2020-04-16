getFormattedDate({DateTime date}) {
  assert(date != null);
  return addToZero(date.day.toString()) +
      "." +
      addToZero(date.month.toString()) +
      "." +
      date.year.toString();
}

String addToZero(String num) {
  if (num.length == 1) return "0" + num;
  return num;
}
