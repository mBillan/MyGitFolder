
String currTimeStyled(){
  DateTime now = DateTime.now();
  return "${now.hour}:${now.minute} ${now.day}/${now.month}/${now.year}";
}
