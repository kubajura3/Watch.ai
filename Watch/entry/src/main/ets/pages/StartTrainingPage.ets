import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Start Training';

  build() {
    // Używamy Column jako głównego kontenera, aby układać elementy pionowo
    Column() {
      // Przycisk 'Go'
      Button() {
        Text('Start')
          .fontSize(20) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      }
      .type(ButtonType.Capsule)
      .margin({ top: 10, bottom: 10 }) // Odpowiednie odstępy
      .backgroundColor(Color.Green)
      // Wymiary z oryginalnego kodu
      .width('60%')
      .height(40)
      .onClick(() => {
        console.info(`Succeeded in clicking the 'Start' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/RunPage'}).then(() => {
          console.info('Succeeded in jumping to the zone page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the zone page. Code is ${err.code}, message is ${err.message}`)
        })
      })

      // Przycisk 'Config'
      Button() {
        Text('Back')
          .fontSize(20) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      }
      .type(ButtonType.Capsule)
      //.margin({ top: 10 })
      .backgroundColor(Color.Red)
      // Wymiary z oryginalnego kodu
      .width('60%')
      .height(40)
      .onClick(() => {
        console.info(`Succeeded in clicking the 'Config' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/Index'}).then(() => {
          console.info('Succeeded in jumping to the config page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the config page.Code is ${err.code}, message is ${err.message}`)
        })
      })
    }
    // Ustawienia dla całego ekranu
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000) // Ciemne tło
    .justifyContent(FlexAlign.Center) // Wyśrodkowanie całej kolumny na środku ekranu
    .padding({ left: 16, right: 16 }) // Marginesy boczne
  }
}