import { ComponentContent, LengthMetrics } from '@kit.ArkUI';
import { UIContext, CircleShape } from '@kit.ArkUI';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import Constant from '../common/constant';
import HeartZone from '../models/model';
import router from '@ohos.router';

@Builder
function buildCrownGestureTitle() {
  Column() {
    // Text("Choose your desired Heart Zone for the training")
    Text("Choose the target pace")
    .fontSize('40px')
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
      .wordBreak(WordBreak.BREAK_WORD)
  }.margin({ top: 20 , bottom: 10}).width('70%')
}

interface ListType {
  isScreenGesture: boolean
}

@Entry
@Component
struct HeartZoneList {
  private gestureList: HeartZone[] = Constant.heartZoneList
  private watchSize: string = '466px'
  private listSize: string = '414px'
  @State isTouchGesture: boolean = true
  context: UIContext = this.getUIContext();
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context,
    wrapBuilder(buildCrownGestureTitle));

  private pageOf(crownIndex?: number): string {
    return `pages/crownGestures/gesture${crownIndex}`
  }

  @Builder
  buildList2() {
    Stack() {
      Column() {
      }
      .justifyContent(FlexAlign.Center)
      .width(this.watchSize)
      .height(this.watchSize)
      .clipShape(new CircleShape({ width: '100%', height: '100%' }))
      .backgroundColor(Color.Black)

      ArcList({ initialIndex: 0, header: this.tabBar1 }) {
        ForEach(this.gestureList, (item: HeartZone, index: number) => {
          ArcListItem() {
            Button(){Column(){
              Text(item.title)
              Text(item.description)}}
              .type(ButtonType.Capsule)
              .width(this.listSize)
              .height('100px')
              .focusable(true)
              .focusOnTouch(true)
              // .backgroundColor(0x17A98D + index * 1000)
            .backgroundColor(0x17A98D + index * 1000)
          }.align(Alignment.Center)
          .onClick(() => {
            AppStorage.setOrCreate('Zone', index);
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/StartTrainingPage',
              // Pass the necessary data in the 'params' object
            })
          })
        }, (item: number, index: number) => (item + index).toString())
      }
      .space(LengthMetrics.px(10))
      .borderRadius(this.watchSize)
      .focusable(true)
      .focusOnTouch(true)
      .defaultFocus(true)
    }
    .align(Alignment.Center)
    .width(this.watchSize)
    .height(this.watchSize)
    .border({ color: Color.Black, width: 1 })
    .borderRadius(this.watchSize)
  }

  build() {
    Column() {
      this.buildList2()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}