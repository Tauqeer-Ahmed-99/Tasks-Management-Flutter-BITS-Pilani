String truncateString(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}

double getAccordionHeight(int numberOfItems) {
  switch (numberOfItems) {
    case 0:
      return 50;
    case 1:
      return 100;
    case 2:
      return 200;
    case 3:
      return 300;
    case 4:
      return 400;
    default:
      return 450;
  }
}
