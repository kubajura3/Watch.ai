import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Walk {

  @State remainingTime: number = 9;

  private timer: number | null = null;

  @State isFinished: boolean = false;

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

    Column() {
      Text('Walk')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)

      Column() {
        Text(this.formatTime(this.remainingTime))
          .fontSize(64)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.isFinished ? '#ED5555' : Color.White)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      if (this.isFinished) {
        Button('End')
          .width('60%')
          .height(40)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .borderRadius(20)
          .backgroundColor(Color.Green)
          .margin({ bottom: 20 })
          .onClick(() => {
            console.info(`Succeeded in clicking the 'End configuration' button in WalkPage.`)
            this.getUIContext().getRouter().pushUrl({url: 'pages/EndConfigurationPage'}).then(() => {
              console.info('Succeeded in jumping to the EndConfiguration page.')
            }).catch((err: BusinessError) => {
              console.error(`Failed to jump to the EndConfiguration page. Code is ${err.code}, message is ${err.message}`)
            })
          })
      } else {
        Button('End')
          .width('60%')
          .height(40)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .borderRadius(20)
          .backgroundColor('#ED5555')
          .margin({ bottom: 20 })
          .onClick(() => {
            console.info(`Succeeded in clicking the 'End' button in WalkPage.`)
            this.getUIContext().getRouter().pushUrl({url: 'pages/Index'}).then(() => {
              console.info('Succeeded in jumping to the Index page.')
            }).catch((err: BusinessError) => {
              console.error(`Failed to jump to the Index page. Code is ${err.code}, message is ${err.message}`)
            })
          })
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