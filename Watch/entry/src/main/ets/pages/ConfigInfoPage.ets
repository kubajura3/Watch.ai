@Entry
@Component
struct WatchInstructionPage {
  // Długi tekst instrukcji do wyświetlenia z numeracją
  private instructionPoints: string[] = [
    '1. At first you will be asked to do a 15 minutes warm-up. Easy run, some jumps, stretching etc, to make your heart beat faster.',
    '2. Next your task is to run with your maximum possible and stable tempo or 20 minutes.',
    '3. At the end you will need to walk for 15 minutes for a cool down.',
    '4. At every step time left will be shown on the screen.'
  ];

  build() {
    Column() { // Główny kontener, układ wertykalny
      // Sekcja przewijana, zajmująca większość przestrzeni
      Scroll() {
        Column({ space: 10 }) {
          // Nagłówek - Zwiększony górny margines
          Text('Instruction')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
            // ZWIĘKSZONY GÓRNY MARGINES
            .margin({ top: 30, bottom: 20 }) // Zmieniono z 10 na 30

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
      Button('Start')
      // ZMNIEJSZONA SZEROKOŚĆ
        .width('30%') //
        // ZMNIEJSZONA WYSOKOŚĆ
        .height(30) // Zmieniono z 36 na 30
        .fontSize(15)
        .borderRadius(15) // Dodanie zaokrąglenia, aby pasowało do mniejszego przycisku
        .margin({ bottom: 10 }) // Mniejszy margines od dolnej krawędzi
        .onClick(() => {
          console.log('Przycisk Next został kliknięty!');
          // Tutaj umieść logikę nawigacji lub inną akcję
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0x000000)
  }
}