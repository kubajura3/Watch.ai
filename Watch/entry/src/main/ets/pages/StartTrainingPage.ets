import { BusinessError } from '@kit.BasicServicesKit';
import { CircleShape } from '@kit.ArkUI'; // Updated import to include Path

@Entry
@Component
struct Index {
  @State message: string = 'Start Training';

  build() {
    // Używamy Column jako głównego kontenera, aby układać elementy pionowo
    Column() {
      // Przycisk 'Go'
      // Button() {
        Text('Start')
          .fontSize(30) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      // }
      // .type(ButtonType.Capsule)
      // .margin({ top: 10, bottom: 10 }) // Odpowiednie odstępy
      .backgroundColor(Color.Green)
      // Wymiary z oryginalnego kodu
      .width('150%')
      .height('50%')
          .radialGradient({
            // Define colors and their stopping points (offsets)
            colors: [
              [Color.Black, 0.0], // Bright Green in the center
              [0x17F98D, 0.7],                   // Standard Green 70% of the way out
              [0x36B079, 1.0]      // Dark Green at the edge
            ],
            // Since we are applying this to a semi-circle, let's keep the center
            // slightly offset to the top edge for a better look on the upper half.
            center: ['50%', '0%'],
            radius: '100%', // Make the radius match the button's largest dimension
          })
      // .type(ButtonType.Normal)
      // .height(40)

      .onClick(() => {
        console.info(`Succeeded in clicking the 'Start' button.`)
        this.getUIContext().getRouter().pushUrl({url: 'pages/RunPage'}).then(() => {
          console.info('Succeeded in jumping to the zone page.')
        }).catch((err: BusinessError) => {
          console.error(`Failed to jump to the zone page. Code is ${err.code}, message is ${err.message}`)
        })
      })

      // Przycisk 'Config'
      // Button() {
        Text('Back')
          .fontSize(30) // Lepszy rozmiar czcionki
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White) // Lepszy kontrast
      // }
      // .type(ButtonType.Capsule)
      //.margin({ top: 10 })
      .backgroundColor(Color.Red)
      // Wymiary z oryginalnego kodu
      .width('150%')
      .height('50%')
          .radialGradient({
            // Define colors and their stopping points (offsets)
            colors: [
              [Color.Black, 0.0], // Bright Green in the center
              // 0x27D09D
              //37C3AD
              //17F98D
              [0x555555, 0.7],                   // Standard Green 70% of the way out
              [0x36B079, 1.0]      // Dark Green at the edge
            ],
            // Since we are applying this to a semi-circle, let's keep the center
            // slightly offset to the top edge for a better look on the upper half.
            center: ['50%', '100%'],
            radius: '100%', // Make the radius match the button's largest dimension
          })
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