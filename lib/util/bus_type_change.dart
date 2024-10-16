String convertBusType(String busType) {
  switch (busType) {
    case '1':
      return '공항';
    case '2':
      return '마을';
    case '3':
      return '간선';
    case '4':
      return '지선';
    case '5':
      return '순환';
    case '6':
      return '광역';
    case '7':
      return '인천';
    case '8':
      return '경기';
    case '9':
      return '폐지';
    case '0':
      return '공용';
    default:
      return '알 수 없음';
  }
}