import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Walk {
  // UWAGA: Zmieniłem remainingTime z powrotem na 900 (15 minut), jeśli chcesz 15 minut.
  // Zostawiłem 9, jak w Twoim kodzie, jeśli używasz tego do szybkiego testowania.
  @State remainingTime: number = 9;

  // Wewnętrzna zmienna do przechowywania ID timera
  private timer: number | null = null;

  // Stan kontrolujący widoczność przycisku Next
  @State isFinished: boolean = false;

  // ... (Logika timera: aboutToAppear, aboutToDisappear, startTimer, stopTimer, formatTime pozostają bez zmian)
  aboutToAppear() {
    this.startTimer();
  }

  aboutToDisappear() {
    this.stopTimer();
  }

  startTimer() {
    if (this.timer) {
      this.stopTimer();
    }

    this.timer = setInterval(() => {
      if (this.remainingTime > 0) {
        this.remainingTime--;
      } else {
        this.stopTimer();
        this.isFinished = true;
      }
    }, 1000);
  }

  stopTimer() {
    if (this.timer !== null) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  formatTime(totalSeconds: number): string {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    const formattedMinutes = minutes.toString().padStart(2, '0');
    const formattedSeconds = seconds.toString().padStart(2, '0');
    return `${formattedMinutes}:${formattedSeconds}`;
  }

  build() {
    // 1. Główna kolumna: rozkłada elementy na górze, w środku i na dole.
    Column() {
      // Nagłówek
      Text('Walk')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        // Zmniejszony margines od góry, aby był wyżej, ale wciąż widoczny
        .margin({ top: 30 })
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)

      // Kontener licznika - używa layoutWeight(1), aby zająć całą środkową przestrzeń
      Column() {
        Text(this.formatTime(this.remainingTime))
          .fontSize(64) // Zwiększony rozmiar czcionki dla lepszej widoczności
          .fontWeight(FontWeight.Medium) // Delikatnie pogrubiony, aby był czytelniejszy
          .fontColor(this.isFinished ? Color.Red : Color.White)
      }
      .width('100%')
      .layoutWeight(1) // Wypycha nagłówek na górę, a przycisk na dół
      .justifyContent(FlexAlign.Center) // Wyśrodkowanie licznika wewnątrz jego przestrzeni

      // Przycisk Next - na samym dole (widoczny tylko po zakończeniu)
      if (this.isFinished) {
        Button('End configuration')
          .width('60%') // Lekko szerszy, ale wciąż kompaktowy
          .height(40) // Lekko wyższy
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .borderRadius(20)
          .backgroundColor(Color.Green) // Zmieniony kolor, by lepiej się wyróżniał po zakończeniu
          .margin({ bottom: 20 }) // Stały margines od dołu, aby nie był obcięty
          .onClick(() => {
            console.info(`Succeeded in clicking the 'End configuration' button in WalkPage.`)
            this.getUIContext().getRouter().pushUrl({url: 'pages/EndConfigurationPage'}).then(() => {
              console.info('Succeeded in jumping to the EndConfiguration page.')
            }).catch((err: BusinessError) => {
              console.error(`Failed to jump to the EndConfiguration page. Code is ${err.code}, message is ${err.message}`)
            })
          })
      } else {
        // Pusty element, który utrzymuje stałą przestrzeń dla przycisku,
        // zapobiegając przesunięciu się licznika po jego pojawieniu
        Row()
          .height(40)
          .margin({ bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    // KLUCZOWA ZMIANA: SpaceBetween rozkłada elementy (nagłówek, licznik, przycisk/Spacer)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(0x000000)
    // Ogólny padding, aby nic nie było za blisko krawędzi
    .padding({ left: 16, right: 16 })
  }
}