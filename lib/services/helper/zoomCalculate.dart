import 'dart:math' as math;
class ZoomCalculate {
  latRad(lat) {
    var sin = math.sin(lat * math.pi / 180);
    var radX2 = math.log((1 + sin) / (1 - sin)) / 2;
    return math.max(math.min(radX2, math.pi), -math.pi) / 2;
  }

  double getZoom(var latA, var lngA, var latB, var lngB) {
    var latDif = (latRad(latA) - latRad(latB)).abs();
    var lngDif = (lngA - lngB).abs();

    var latFrac = latDif / math.pi;
    var lngFrac = lngDif / 360;

    var lngZoom = math.log(1 / latFrac) / math.log(2);
    var latZoom = math.log(1 / lngFrac) / math.log(2);
    print(math.min(lngZoom, latZoom).toString());
    return math.min(lngZoom, latZoom);
  }
}