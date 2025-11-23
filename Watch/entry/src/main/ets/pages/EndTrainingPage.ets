import HeartRateSensor from '../demo/BpmDemo';
import PaceMonitor from '../demo/PaceDemo';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct EndTrainingPage {
  @StorageLink('Zone') zone: number = 0;
  build() {
    // Main Column
    Column() {
      // Metrics Section (BPM and Pace)

      // 1. Heart Rate Section (BPM)
      Column() {
        Text('Mean BPM')
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)

        Text(HeartRateSensor.getHeartRateMean().toFixed(2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ top: 25, bottom: 10 }) // This creates the top spacing

      // 2. Heart Zone
      Column() {
        Text('Your Heart Zone')
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)

        Text('Zone ' + (this.zone+1).toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ bottom: 10 }) // Add consistent bottom margin

      // 3. Pace Section
      Column() {
        Text(`Pace`)
          .fontSize(12)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)

        Text('5.22')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .margin({ bottom: 10 }) // Use margin instead of padding for consistent spacing
      // Removed the .padding(20) and used consistent margin

      // 4. End Button
      Button() {
        Text('OK')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .type(ButtonType.Capsule)
      .width('60%')
      .height(40)
      .backgroundColor('#17C97D')
      .margin({ bottom: 10 })
      .onClick(() => {
        console.info(`Succeeded in clicking 'End'.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/Index'}).then(() => {
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