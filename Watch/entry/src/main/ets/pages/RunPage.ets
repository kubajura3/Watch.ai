import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
// import HeartRateSensor from '../sensors/hrSensor';
import HeartRateSensor from '../demo/BpmDemo';
import PaceMonitor from '../demo/PaceDemo';

import { KalmanFilter } from '../common/KalmanFilter';
import { updateAndPredictAhead } from '../common/update-and-predict';
import { CreateU } from '../common/control-update';
import router from '@ohos.router';
// Import the singleton database manager
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
  @State kAhead: number = 3
  @State measurement: number = 10
  @State stateNow: number = 0
  @State predictedState: number = 0
  @State Delay: number = 5000
  @State TimePassed: number = 0

  @StorageLink('Zone') zone: number = 0;

  private filter: KalmanFilter = new KalmanFilter(
    5,
    1,
    0.95,
    0.1,
    1,
    1,
    CreateU(this.u)
  )

  private atManager: abilityAccessCtrl.AtManager | null = null
  private context: common.UIAbilityContext | undefined = undefined

  // Style constants
  private buttonWidth: string = '60%';
  private buttonHeight: number = 40;
  private dividerColor: Color = Color.White;

  private hrListener = (hr: number) => {
    this.heartRate = hr
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
    this.measurement = this.heartRate + 1

    // --- DATABASE OPERATION ---
    // Save the measurement to the RDB Store
    // We do not await here to prevent blocking the UI/Logic loop

    // --------------------------

    this.u = [this.measurement, this.currentPace, this.TimePassed * this.Delay]
    const result = updateAndPredictAhead(
      this.filter,
      this.measurement,
      CreateU(this.u),
      this.kAhead
    )

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
      Column() {
        // 1. Heart Rate Section (BPM)
        Column() {
          Text('BPM')
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.Gray)

          Text(this.heartRate.toString())
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .margin({ top: 20, bottom: 10 })

        // 2. Divider
        Divider()
          .strokeWidth(2)
          .color(this.dividerColor)
          .width('50%')
          .margin({ bottom: 10 })

        // 3. Pace Section
        Column() {
          Text(`Pace:`)
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
        .margin({ bottom: 20 })
      }

      // 4. End Button
      Button() {
        Text('End')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .type(ButtonType.Capsule)
      .width(this.buttonWidth)
      .height(this.buttonHeight)
      .backgroundColor(Color.Red)
      .margin({ bottom: 10 })
      .onClick(() => {
        console.info(`Succeeded in clicking 'End'.`)
        // Ensure the path 'pages/SummaryPage' exists in your main_pages.json
        this.getUIContext().getRouter().pushUrl({url: 'pages/SummaryPage'}).then(() => {
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