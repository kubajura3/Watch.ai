import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import HeartRateSensor from '../sensors/hrSensor';
import { KalmanFilter } from '../common/KalmanFilter';
import { updateAndPredictAhead } from '../common/update-and-predict';
import { CreateU } from '../common/control-update';
import router from '@ohos.router';
// Import the singleton database manager
@Entry
@Component
struct ActivityMonitorPage {
  // Simulation/Dynamic Data
  @State heartRate: number = 5
  @State currentPace: number = 300; // Pace in min:sec/km
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

  formatPace(sec: number): string {
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return `${m}:${s.toString().padStart(2, '0')}`;
  }

    async aboutToAppear(): Promise<void> {

    HeartRateSensor.subscribe(this.hrListener)

    this.paceInterval = setInterval(() => {
      this.checkPace();
    }, this.Delay);
  }

  aboutToDisappear(): void {
    clearInterval(this.paceInterval);
    HeartRateSensor.unsubscribe(this.hrListener)
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

          Text(this.formatPace(this.currentPace))
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