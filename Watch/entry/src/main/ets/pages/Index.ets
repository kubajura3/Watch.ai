import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Start Training';

  build() {
    // Używamy Column jako głównego kontenera, aby układać elementy pionowo
    Column() {

      // Nagłówek 'Start Training'
      Text(this.message)
        .fontSize(36) // Lepszy rozmiar na zegarek
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ top: 8, bottom: 5 }) // Większy odstęp pod nagłówkiem
      // Usuwamy alignRules - wystarczy wyśrodkowanie kolumny

      // Przycisk 'Go'
      Button() {
        Text('Go')
          .fontSize(20) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      }
      .type(ButtonType.Capsule)
      .margin({ top: 10, bottom: 10 }) // Odpowiednie odstępy
      .backgroundColor('#0D9FFB')
      // Wymiary z oryginalnego kodu
      .width('60%')
      .height(40)
      .onClick(() => {
        console.info(`Succeeded in clicking the 'Go' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/StartTrainingPage'}).then(() => {
          console.info('Succeeded in jumping to the zone page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the zone page.Code is ${err.code}, message is ${err.message}`)
        })
      })

      // Przycisk 'Config'
      Button() {
        Text('Config')
          .fontSize(20) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      }
      .type(ButtonType.Capsule)
      //.margin({ top: 10 })
      .backgroundColor('#0D9FFB')
      // Wymiary z oryginalnego kodu
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
    // Ustawienia dla całego ekranu
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000) // Ciemne tło
    .justifyContent(FlexAlign.Center) // Wyśrodkowanie całej kolumny na środku ekranu
    .padding({ left: 16, right: 16 }) // Marginesy boczne
  }
}