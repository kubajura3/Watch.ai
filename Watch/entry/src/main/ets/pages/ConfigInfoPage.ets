import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WatchInstructionPage {

  private instructionPoints: string[] = [
    '1. At first you will be asked to do a 15 minutes warm-up. Easy run, some jumps, stretching etc, to make your heart beat faster.',
    '2. Next your task is to run with your maximum possible and stable tempo or 20 minutes.',
    '3. At the end you will need to walk for 15 minutes for a cool down.',
    '4. At every step time left will be shown on the screen.'
  ];

  build() {
    Column() {

      Scroll() {
        Column({ space: 10 }) {

          Text('Instruction')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 30, bottom: 20 })

          Column({ space: 10 }) {
            ForEach(this.instructionPoints, (item: string) => {
              Text(item)
                .fontSize(14)
                .fontWeight(FontWeight.Normal)
                .textAlign(TextAlign.Start)
                .textOverflow({ overflow: TextOverflow.None })
                .maxLines(10)
                .width('90%')
                .alignSelf(ItemAlign.Center)
            })
          }
        }
        .padding({ left: 18, right: 18, bottom: 20 })
        .width('100%')
      }
      .layoutWeight(1)

      Button('Start')
        .width('30%')
        .height(30)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .borderRadius(15)
        .margin({ bottom: 10 })
        .onClick(() => {
          console.info(`Succeeded in clicking the 'Start' button in ConfigInfo.`)
          this.getUIContext().getRouter().pushUrl({url: 'pages/WarmUpPage2'}).then(() => {
            console.info('Succeeded in jumping to the WarmUp page.')
          }).catch((err: BusinessError) => {
            console.error(`Failed to jump to the WarmUp page. Code is ${err.code}, message is ${err.message}`)
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000)
  }
}