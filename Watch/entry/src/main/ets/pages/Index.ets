import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Start Training';

  build() {
    Column() {

      Text(this.message)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ top: 8, bottom: 5 })


      Button() {
        Text('Go')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .type(ButtonType.Capsule)
      .margin({ top: 10, bottom: 10 })
      .backgroundColor('#0D9FFB')
      .width('60%')
      .height(40)
      .onClick(() => {
        console.info(`Succeeded in clicking the 'Go' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/ChooseZone'}).then(() => {
          console.info('Succeeded in jumping to the zone page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the zone page.Code is ${err.code}, message is ${err.message}`)
        })
      })

      Button() {
        Text('Config')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .type(ButtonType.Capsule)
      //.margin({ top: 10 })
      .backgroundColor('#0D9FFB')
      .width('60%')
      .height(40)
      .onClick(() => {
        console.info(`Succeeded in clicking the 'Config' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/ConfigInfoPage'}).then(() => {
          console.info('Succeeded in jumping to the config page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the config page.Code is ${err.code}, message is ${err.message}`)
        })
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16 })
  }
}