public class TimelineView {
  float sideScalesWidth = 100.0;
  float timelineWidth = 1000.0;

  float rmsGraphHeight = 175;
  float spectrogramHeight = 700;
  float bottomScalesHeight = 75;

  float Width, Height;

  // to control the time bar
  float position;
  float range;
  float takeToReach = 10.0; 
  float speed = 0.0; // px/s
  float gapTime = 0;
  float round = 0;


  // to control the time scale
  int count = 0;
  int interval;
  int breakTime = 0;
  int breakStartTime = 0;
  float scaleDrawPoint = -100;
  boolean goBack = false;

  // others
  float fadeout = 100;


  RMSGraph rmsGraph;
  Spectrogram spectrogram;



  public TimelineView() {
    Width = sideScalesWidth + timelineWidth;
    Height = rmsGraphHeight + spectrogramHeight + bottomScalesHeight;

    rmsGraph = new RMSGraph(sideScalesWidth, 0, timelineWidth, rmsGraphHeight, 150);
    spectrogram = new Spectrogram(
      sideScalesWidth, rmsGraph.Y + rmsGraph.Height, 
      timelineWidth, spectrogramHeight);

    position = sideScalesWidth;
    speed = (float)timelineWidth / takeToReach;
  }



  public void InitializeTheTimeScale(int interval) {
    this.interval = interval;
    breakTime = millis();
    breakStartTime = millis();
  }


  public void DrawTimeline(float fTime, float rms, float[] spectrum) {
    CalculateRange(fTime);

    Visualize(position, range, rms, spectrum);
    DrawTheTimeScale("ANY");

    position += range;
    if (position > Width) {
      position -= timelineWidth;
      DrawTheTimeScale("BACK");
      ManageTheTimelineSpeed(millis() - breakTime);
      goBack = true;
    } else {
      goBack = false;
    }
  }


  public void CalculateRange(float deltaTime) {
    range = speed * deltaTime; // px/f
  }



  public void Visualize(float p, float r, float rms, float[] spectrum) {
    UpdateTheTimeline(p, r, rms, spectrum);
    if (p + r + fadeout > Width) {
      UpdateTheTimeline(p - timelineWidth, r, rms, spectrum);
    }
  }


  public void UpdateTheTimeline(float p, float r, float rms, float[] spectrum) {
    r++;

    // clear the drawing region
    noStroke();
    fill(0);
    rect(p, 0, r, Height);
    fill(0, 15);
    rect(p + r, 0, fadeout, Height); // feed out


    // Draw RMS Graph
    rmsGraph.DrawRMSGraph(rms, p, r);

    // Draw Spectrogram
    spectrogram.DrawSpectrogram(spectrum, p, r);

    // Draw time bar
    DrawTheTimeBar(p, r);
  }

  void DrawTheTimeBar() {
    noStroke();
    fill(200);
    rect(position + range + 1, 0, 2, Height);
  }

  void DrawTheTimeBar(float p, float r) {
    noStroke();
    fill(200);
    rect(p + r + 1, 0, 2, Height);
  }

  // Vertical line
  public void DrawTheTimeScale(String state) {
    int pass = millis() - breakTime; // passed time from start of drawing
    float time = (float)pass / 1000.0;


    noStroke();
    textAlign(RIGHT, TOP);
    if (position + range > Width || state == "BACK") {
      fill(80, 100, 170);
      rect(position, 0, 2, Height);
      text(time, position, Height - bottomScalesHeight + 30);
      // scaleDrawPoint = position;
    } else if ((pass - count * interval >= interval) && (abs(position - scaleDrawPoint) > 70) && state == "ANY") {
      fill(70, 170, 50);
      rect(position, 0, 2, Height);
      text(time, position, Height - bottomScalesHeight + 10);
      scaleDrawPoint = position;
      count++;
    } else if (state == "CONTROLED") {
      if (position == 0) {
        fill(80, 100, 170);
        rect(position - 2, 0, 2, Height);
        text(time, position - 2, Height - bottomScalesHeight + 30);
      } else {
        fill(0, 100);
        rect(position - 90, Height - bottomScalesHeight + 48, 90, 18);
        fill(170, 50, 70);
        rect(position - 2, 0, 2, Height);
        text(time, position - 2, Height - bottomScalesHeight + 50);
      }
    }
  }

  public boolean ControlTheTimeline(boolean playing) {
    if (playing) {
      breakStartTime = millis();
      playing = false;
    } else {
      breakTime += millis() - breakStartTime;
      playing = true;
    }

    return playing;
  }

  public void ManageTheTimelineSpeed(int passTime) {
    round++;
    gapTime = passTime / 1000.0 - takeToReach * round;
    // println("gap: " + gapTime);
    speed  = (timelineWidth + speed * gapTime) / takeToReach;
  }
}
