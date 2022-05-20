public static class Time {
  private static int frameCount = 0; // 経過したフレーム数
  private static int passTime = 0; // プログラム経過時間(ms)

  public static int deltaTime = 0; // 1フレームの処理時間(ms)
  public static float deltaTimeSec = 0.0; // 1フレームの処理時間(s)
  
  private static ArrayList<Integer> deltaTimeData;
  private static int totalTime = 0;
  public static int measuringCountParSec; // MCPS
  public static float fps = 0; 



  /////////////////////////////////////////////////////////////////////////////////
  // 計測関数
  public static void Measure(PApplet pApplet) {
    if (passTime == 0) {
      Initialization(pApplet);
      return;
    }

    int time =  pApplet.millis();
    DeltaTime(pApplet.frameCount, time); // フレームの処理時間計測
    fps = 1.0 / deltaTimeSec;
    
    CalcMeasureCount(); // MCPSの計算
  }
  
  
  
  ////////////////////////////////////////////////////////////////////////////////////
  // フレームの処理時間計測関数
  // 引数（現在のフレームの処理回数，現在のプログラムの経過時間）
  // 内容（1フレームにつき1回だけ処理する．フレームの処理時間を求める）
  private static void DeltaTime(int count, int time) {
    if (frameCount == count) {
      return;
    }
    deltaTime = time - passTime; // フレームの処理時間を格納
    deltaTimeSec = MSToS(deltaTime); // フレームの処理時間を秒単位に変更
    passTime = time; // 現在のプログラムの経過時間を格納

    frameCount = count; // 現在のフレームの処理回数を格納
  }



  //////////////////////////////////////////////////////////////////////////////////
  // その他の関数

  // msecの値→sの値に変換する．（小数点2桁で四捨五入される）
  private static float MSToS(int msValue) {
    return (float)msValue / 1000.0;
  }
  
  // クラスの値の初期化ができる関数
  public static void Initialization(PApplet pApplet) {
    passTime = pApplet.millis(); // プログラムの経過時間を格納
    deltaTime = passTime; // 経過時間をフレームの処理時間にする
    deltaTimeSec = MSToS(deltaTime); // 小数点第２位を四捨五入して秒に変換
    
    // 計測関数が1秒間に何回呼び出されたかを計測する関数に使用するリストの初期化
    deltaTimeData = new ArrayList<Integer>();
    totalTime = 0;
  }
  
  private static void CalcMeasureCount() {
    deltaTimeData.add(deltaTime); // リストに値を追加
    totalTime += deltaTime; // 合計時間に値を加算
    measuringCountParSec = deltaTimeData.size(); // リストのサイズをMCPSとする
    
    // 合計時間が1000ms以下になるようにリストを調整
    while(totalTime > 1000) {
      totalTime -= deltaTimeData.get(0);
      deltaTimeData.remove(0);
    }
  }
}
