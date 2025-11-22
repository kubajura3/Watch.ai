import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct MaxStableTempo {

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
      Text('Max stable tempo')
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
          .fontColor(this.isFinished ? Color.Red : Color.White)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      if (this.isFinished) {
        Button('Next')
          .width('60%')
          .height(40)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .borderRadius(20)
          .backgroundColor(Color.Green)
          .margin({ bottom: 20 })
          .onClick(() => {
            console.info(`Succeeded in clicking the 'Next' button in MaxStableTempoPage.`)
            this.getUIContext().getRouter().pushUrl({url: 'pages/WalkPage'}).then(() => {
              console.info('Succeeded in jumping to the Walk page.')
            }).catch((err: BusinessError) => {
              console.error(`Failed to jump to the Walk page. Code is ${err.code}, message is ${err.message}`)
            })
          })
      } else {
        Button('End')
          .width('60%')
          .height(40)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .borderRadius(20)
          .backgroundColor(Color.Red)
          .margin({ bottom: 20 })
          .onClick(() => {
            console.info(`Succeeded in clicking the 'End' button in MaxStableTempoPage.`)
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
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(0x000000)
    .padding({ left: 16, right: 16 })
  }
}