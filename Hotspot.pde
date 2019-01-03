class Hotspot {
  float limXA;
  float limXB;
  float limYA;
  float limYB;
  boolean tocado;
  color col;

  Hotspot(float _limXA, float _limXB, float _limYA, float _limYB, color _col) {
    limXA = _limXA;
    limXB = _limXB;
    limYA = _limYA;
    limYB = _limYB;
    col = _col;
  }
  ////DIBUJA ZONA mal posicion problemas de translate
  void display() {
    noFill();
    stroke(col);
    strokeWeight(1);
    rectMode(CORNERS);
    translate((limXA+limXB)/2, 0, (limYA+limYB)/2);
    rect(0, 0, 50, 50);
  }

  boolean esTocada(float _x, float _y) {
    if (_x > limXA && _x < limXB && _y > limYA && _y < limYB) {
      tocado = true;
    } else {
      tocado = false;
    }
    return tocado;
  }
}

