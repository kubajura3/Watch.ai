import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Start Training';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        Button() {
          Text('Go')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({top: 20})
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('20%')
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
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({top: 20})
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('20%')
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
    }
    .height('100%')
  }
}