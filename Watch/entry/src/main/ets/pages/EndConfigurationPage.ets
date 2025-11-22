import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WatchInstructionPage {
  // Długi tekst instrukcji do wyświetlenia z numeracją
  private instructionPoints: string[] = [
    'You initial data already gathered. It will be sent to the server as soon as you will have internet connection, to train our models and provide you with the best heart rate zone assistance for your trainings.'
  ];

  build() {
    Column() { // Główny kontener, układ wertykalny
      // Sekcja przewijana, zajmująca większość przestrzeni
      Scroll() {
        Column({ space: 10 }) {
          // Nagłówek - Zwiększony górny margines
          Text('Configuration ended')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            // ZWIĘKSZONY GÓRNY MARGINES
            .margin({ top: 40, bottom: 10 }) // Zmieniono z 10 na 30

          // Lista punktów z numeracją
          Column({ space: 10 }) { // Odstęp między punktami
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
        .padding({ left: 18, right: 18, bottom: 20 }) // Globalne paddingi
        .width('100%')
      }
      .layoutWeight(1) // Sekcja przewijana zajmuje całą dostępną przestrzeń

      // Przycisk "Next" - znacznie krótszy i niższy
      Button('OK')
      // ZMNIEJSZONA SZEROKOŚĆ
        .width('30%') //
        // ZMNIEJSZONA WYSOKOŚĆ
        .height(30) // Zmieniono z 36 na 30
        .fontSize(15)
        .borderRadius(15) // Dodanie zaokrąglenia, aby pasowało do mniejszego przycisku
        .margin({ bottom: 10 }) // Mniejszy margines od dolnej krawędzi
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