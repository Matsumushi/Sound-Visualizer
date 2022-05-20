import processing.sound.*;

////////////////////////////////////////////////////////////////////////////
// Variables
// to control program
boolean isPlaying = false;

// to deal with sound file
String fileName;
SoundFile sf;

// for fft analysis
FFT fft;
int bands = 4096;
float[] spectrum = new float[bands];

// for rms analysis
Amplitude amplitude;
float rms = 0;


// adding
TimelineView timelineView;
SpectrumGraph spectrumGraph;

void setup() {
  //========================================================================
  // Initialize widow and drawing area
  SetWindow("Sound Visualizer for Sound Files", new PVector(100, 0));
  size(1700, 950, P2D);
  background(0);

  //========================================================================
  // Initialize variables
  timelineView = new TimelineView();
  spectrumGraph = new SpectrumGraph(timelineView.Width, timelineView.rmsGraphHeight, 600, timelineView.spectrogramHeight);
  spectrumGraph.Setup(bands);
  for (int i = 0; i < bands; i++) {
    spectrum[i] = 0;
  }

  fileName = "Let's explore this beautiful world!.wav";
  sf = new SoundFile(this, fileName);
  sf.rate(0.9);
  fft = new FFT(this, bands);
  fft.input(sf);
  amplitude = new Amplitude(this);
  amplitude.input(sf);

  //========================================================================
  // set text parameter
  // printArray(PFont.list());
  // textFont(createFont("UD デジタル 教科書体 NP-R", 48));
  textFont(loadFont("UDDigiKyokashoNK-R-48.vlw"));
  textSize(18);
  textAlign(RIGHT, TOP);
  strokeWeight(2.0);

  //========================================================================
  // first measurement
  timelineView.InitializeTheTimeScale(2500);
  
  timelineView.DrawTimeline(0, 0, spectrum);
}


void draw() {
  Time.Measure(this);

  if (isPlaying) {
    //========================================================================
    // sound analysis
    // fft
    fft.analyze(spectrum);
    rms = amplitude.analyze();
    timelineView.DrawTimeline(Time.deltaTimeSec, rms, spectrum);
  } else {
    timelineView.DrawTheTimeBar();
  }
  
  

  if (!sf.isPlaying()) {
    if (isPlaying) {
      sf.jump(0.0);
    }
  }

  spectrumGraph.UpdateSpectrumGraph(spectrum, isPlaying);

  //========================================================================
  // draw scales
  timelineView.spectrogram.DrawScales(0, 100, width);
  timelineView.rmsGraph.DrawScales(0, 100, timelineView.Width);


  //========================================================================
  // other regions
  Information();
}


////////////////////////////////////////////////////////////////////////////
// Key event
void mousePressed() {
  isPlaying = timelineView.ControlTheTimeline(isPlaying);
  timelineView.DrawTheTimeScale("CONTROLED");
  if (sf.isPlaying()) {
    sf.pause();
  } else {
    sf.play();
  }
}


/////////////////////////////////////////////////////////////////////////////
// functions
void SetWindow(String windowName, PVector location) {
  surface.setResizable(true); // make the window size variable
  surface.setTitle(windowName); // set the title of this sketch
  surface.setLocation((int)location.x, (int)location.y); // set the location of the sketch's window
}




////////////////////////////////////////////////////////////////////////////
// Information
void Information() {
  noStroke();
  fill(0);
  rect(timelineView.Width, 0, spectrumGraph.Width, timelineView.rmsGraphHeight);
  fill(0, 255, 255);
  rect(timelineView.Width, 0, 2, timelineView.rmsGraph.Height);
  rect(timelineView.Width, timelineView.rmsGraph.Height - 2, width - timelineView.Width, 2);

  textAlign(LEFT, TOP);

  fill(255);
  text("Status: ", 1150, 20);
  if (isPlaying) {
    fill(255, 150, 100);
    text("PlAYING", 1220, 20);
  } else {
    fill(100, 250, 150);
    text("BREAKING", 1220, 20);
  }

  fill(176, 155, 80);
  text("Frame Rate: " + Time.measuringCountParSec + " f/s", 1350, 20);

  fill(155, 114, 176);
  text("Sound File Name: " + fileName, 1150, 50);
  text("Duration: " + sf.duration() + " s", 1150, 70);

  fill(169, 255, 137);
  text("Number of frequency bands for the FFT: " + bands, 1150, 100);
}
