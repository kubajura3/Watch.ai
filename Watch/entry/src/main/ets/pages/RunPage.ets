import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
// import HeartRateSensor from '../sensors/hrSensor';
// import PaceMonitor from '../sensors/paceSensor';
import HeartRateSensor from '../demo/BpmDemo';
import PaceMonitor from '../demo/PaceDemo';
import { KalmanFilter } from '../common/KalmanFilter';
import { updateAndPredictAhead } from '../common/update-and-predict';
import { CreateU } from '../common/control-update';
import { vibrator } from '@kit.SensorServiceKit';

@Entry
@Component
struct ActivityMonitorPage {
  // Simulation/Dynamic Data
  @State heartRate: number = 0;  // bpm
  @State paceMonitor: string = '--:--'; // pace in min:sec / km format
  @State currentPace:  number = 0; // s/km


  // model params
  private paceInterval: number = 0;
  @State u: number[] = [0, 0, 0] // bpm, pace, time
  @State kAhead: number = 10
  @State measurement: number = 10
  @State stateNow: number = 0
  @State predictedState: number = 0
  @State Delay: number = 600
  @State TimePassed: number = 0
  @State Vibrated: boolean = false
  @State bpm_limit: number = 0

  @StorageLink('Zone') zone: number = 0;
  @StorageLink('Zone_desc') bpm_range: string = "bpm";

  private filter: KalmanFilter = new KalmanFilter(
    100,
    1,
    0.85,
    7.890117936233612,
    1,
    1,
    [ 0.09047265, 0.00097018,  0.19004]
  )

  private atManager: abilityAccessCtrl.AtManager | null = null
  private context: common.UIAbilityContext | undefined = undefined

  // Style constants
  private buttonWidth: string = '60%';
  private buttonHeight: number = 40;
  private dividerColor: Color = Color.White;

  private hrListener = (hr: number) => {
    this.heartRate = hr
    this.heartRate -= (168 - this.bpm_limit)
  }

  private pmListener = (cp: number, pm: string)=>{
    this.paceMonitor = pm
    this.currentPace = cp
  }

  async requestPermissionsAndStart(): Promise<void> {
    const perms: Permissions[] = [
      'ohos.permission.READ_HEALTH_DATA',
      'ohos.permission.APPROXIMATELY_LOCATION',
      'ohos.permission.LOCATION',

    ];
    try {
      if (this.atManager && this.context) {
        const result = await this.atManager.requestPermissionsFromUser(this.context, perms)
        console.log('Permission request result: ' + JSON.stringify(result))
      }
    } catch (err) {
      console.error('Request permission failed: ' + JSON.stringify(err))
    }
  }

  checkPace() {
    this.measurement = this.heartRate

    // --- DATABASE OPERATION ---
    // Save the measurement to the RDB Store
    // We do not await here to prevent blocking the UI/Logic loop

    // --------------------------

    this.u = [(this.TimePassed * this.Delay / 8000)%6, this.measurement]
    const result = updateAndPredictAhead(
      this.filter,
      this.measurement,
      CreateU(this.u),
      this.kAhead
    )
    if(result.predictedState < this.bpm_limit - 4){
      this.Vibrated = false
    }
    if(result.predictedState > 170 && this.Vibrated == false){
      vibrator.vibrate(2000)
      console.log(this.TimePassed + "     exceeded     " + result.predictedState)
      this.Vibrated = true
    }
    this.TimePassed += 1
  }

  aboutToAppear(): void {
    try{
      this.context = this.getUIContext().getHostContext() as common.UIAbilityContext
    }catch{
      this.context = undefined
    }

    this.atManager = abilityAccessCtrl.createAtManager()
    this.requestPermissionsAndStart()

    this.bpm_limit = parseInt(this.bpm_range.slice(-7, -4))
    console.log(this.bpm_limit.toString())

    HeartRateSensor.subscribe(this.hrListener)
    PaceMonitor.subscribe(this.pmListener)

    this.paceInterval = setInterval(() => {
      this.checkPace();
    }, this.Delay);
  }

  aboutToDisappear(): void {
    clearInterval(this.paceInterval);
    HeartRateSensor.unsubscribe(this.hrListener)
    PaceMonitor.unsubscribe(this.pmListener)
  }

  build() {
    // Main Column
    Column() {
      // Metrics Section (BPM and Pace)

      // 1. Heart Rate Section (BPM)
      Column() {
        Text('BPM')
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)

        Text(this.heartRate.toFixed(2))
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ top: 25, bottom: 10 })

      // 2. Divider
      Divider()
        .strokeWidth(2)
        .color(this.dividerColor)
        .width('60%')

      // 3. Pace Section
      Column() {
        Text(`Pace`)
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)

        Text(this.paceMonitor)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }

      .padding(20)
      .width('100%')
      .margin({ top: 0, bottom: 5 })


      // 4. End Button
      Button() {
        Text('End')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .type(ButtonType.Capsule)
      .width(this.buttonWidth)
      .height(this.buttonHeight)
      .backgroundColor('#ED5555')
      .margin({ bottom: 10 })
      .onClick(() => {
        console.info(`Succeeded in clicking 'End'.`)
        // Ensure the path 'pages/SummaryPage' exists in your main_pages.json
        this.getUIContext().getRouter().pushUrl({url: 'pages/EndTrainingPage'}).then(() => {
          console.info('Succeeded in jumping to the Summary page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to SummaryPage. Code is ${err.code}, message is ${err.message}`)
        })
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000)
    .padding({ left: 16, right: 16 })
  }
}