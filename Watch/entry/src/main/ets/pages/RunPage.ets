import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct ActivityMonitorPage {
  // Dane symulacyjne/dynamiczne
  @State currentBPM: number = 135;  // Tętno w uderzeniach na minutę
  @State currentPace: string = '05:30'; // Tempo w formacie minuty:sekundy/km

  // Stałe dla stylów
  private buttonWidth: string = '60%';
  private buttonHeight: number = 40;
  private dividerColor: Color = Color.White;

  build() {
    // Główna kolumna, używa SpaceBetween, aby wypchnąć przycisk na dół
    Column() {
      // Sekcja Metryk (BPM i Pace)
      Column() {
        // 1. Sekcja Tętna (BPM)
        Column() {
          Text('BPM')
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.Gray)

          Text(this.currentBPM.toString())
          // ZMNIEJSZONA CZCIONKA
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .margin({ top: 20, bottom: 10 })

        // 2. Separator (Pozioma kreska)
        Divider()
          .strokeWidth(2)
          .color(this.dividerColor)
          .width('50%')
          .margin({ bottom: 10 })

        // 3. Sekcja Tempa (Pace)
        Column() {
          Text('Pace (min/km)')
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.Gray)

          Text(this.currentPace)
          // ZMNIEJSZONA CZCIONKA
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .margin({ bottom: 20 }) // Dodatkowy margines, aby oddzielić od przycisku
      }
      //.layoutWeight(1) // Ten kontener zajmuje całą dostępną przestrzeń

      // 4. Przycisk 'End' na dole
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