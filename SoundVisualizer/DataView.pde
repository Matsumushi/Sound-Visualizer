public class DataView {
  public float X = 0;
  public float Y = 0;
  public float Width = 0;
  public float Height = 0;

  public DataView(float x, float y, float w, float h) {
    X = x;
    Y = y;
    Width = w;
    Height = h;
  }
}





public class Spectrogram extends DataView {

  public Spectrogram(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  public void DrawSpectrogram(float[] spectrum, float p, float r) {
    float v = Height / (float)spectrum.length;
    noStroke();
    for (int i = 0; i < spectrum.length; i++) {
      fill(255.0 * spectrum[i] * 10);
      rect(p, (Height + Y) - i * v, r, v);
    }
  }

  public void DrawScales(float sPosX, float areaWidth, float w) {
    // clear the drawing area
    noStroke();
    fill(0, 5);
    rect(sPosX, Y, areaWidth, Height); 

    int count = 10;
    int sfreq = 44100;

    float scale = float(sfreq / 2 / count);
    float interval = Height / (float)count;

    for (int i = 0; i < count; i++) {
      fill(0, 170, 0);
      textAlign(RIGHT, BOTTOM);
      rect(0, (Y + Height) - interval * i, w, 2);
      text(int(scale * i), sPosX + 90, (Y + Height) - interval * i);
    }
  }
}





public class RMSGraph extends DataView {
  float range = 1.0;

  public RMSGraph(float x, float y, float w, float h, float range) {
    super(x, y, w, h);
    this.range = range;
  }

  public void DrawRMSGraph(float rms, float p, float r) {
    float topPosition = rms * range;
    
    noStroke();
    fill(255);
    rect(p, (Height + Y) - topPosition, r, topPosition);
  }

  public void DrawScales(float sPosX, float areaWidth, float w) {
    int count = 4;
    float scale = 1.0 / (float)count;
    float interval = range / (float)count;
    
    // clear the drawing area
    noStroke();
    fill(0, 5);
    rect(sPosX, Y, areaWidth, Height);

    fill(0, 150, 200);
    for (int i = 0; i <= count; i++) {
      rect(sPosX, (Y + Height) - i * interval - 2, w, 2);
      textAlign(RIGHT, BOTTOM);
      text((float)i * scale, sPosX + 90, (Y + Height) - interval * i);
    }
  }
}



public class SpectrumGraph extends DataView {
  int bands;
  float v;

  public SpectrumGraph(float x, float y, float w, float h) {
    super(x, y, w, h);
  }

  public void Setup(int bands) {
    this.bands = bands;
    v = Height / bands;
  }

  void UpdateSpectrumGraph(float[] spectrum, boolean playing) {
    if (playing) {
      // clear the drawing region
      noStroke();
      fill(0);
      rect(X, Y, Width, Height);

      for (int i = 0; i < bands; i++) {
        float value = map(spectrum[i], 0, 1.5, 0, Width);
        fill(255);
        rect(1100, (Height + Y) - i * v, value, v);
      }
    }

    DrawSpectrumScale();
  }

  void DrawSpectrumScale() {
    noStroke();
    fill(0);
    rect(X, Y + Height, Width, height - (Y + Height));

    float interval = Width / 5.0;
    float scale = 1.5 / 5.0;
    fill(242, 90, 121);
    for (int i = 0; i < 5; i++) {
      rect(interval * i + X, Y, 3, height - Y);
      textAlign(LEFT, TOP);
      text((float)i * scale, interval * i + X, Y + Height + 10);
    }
  }
}
