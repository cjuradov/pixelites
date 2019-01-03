class Grid {
  int cantCol;
  int cantFil;
  int ancho;
  int alto;

  Grid() {
    cantCol = 16;
    cantFil = 12;
    ancho = width / cantCol;
    alto = height / cantFil;
  }
  void dibujar(float escala) {
    scale(escala);
    for (int i=0; i<cantCol; i++) {
      for (int j=0; j<cantFil; j++) {
        float x = i*ancho;
        float y = j*alto;
        // noStroke();
        colorMode(HSB);
        c = c + dir * 0.01;
        if  ((c >= 255) || (c < 0)) {
          dir = dir * -1;
          // if (frameCount % 15 == 0) {
        }
        fill(c, 255, random(0, 127.5));
        rectMode(CORNER);
        rect(x, y, ancho, alto);
      }
    }
  }
}

