import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WatchInstructionPage {
  private instructionPoints: string[] = [
    'hackaTUM2025 submssion deadline in 5 minutes!!!'
  ];

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
          Text('HEART ATTACK')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 40, bottom: 10 })

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

      Button('OK...')
        .width('30%')
        .height(30)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .borderRadius(15)
        .backgroundColor('#17C97D')
        .margin({ bottom: 10 })
        .onClick(() => {
          console.info(`Succeeded in clicking the 'OK' button in EndConfigurationPage.`)
          this.getUIContext().getRouter().pushUrl({url: 'pages/Index'}).then(() => {
            console.info('Succeeded in jumping to the Index page.')
          }).catch((err: BusinessError) => {
            console.error(`Failed to jump to the Index page. Code is ${err.code}, message is ${err.message}`)
          })
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000)
  }
}