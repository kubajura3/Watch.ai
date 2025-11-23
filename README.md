# Welcome to Watch.ai
## Project implemented during hackatum2025.
## Team: Jakub Jura, Agata Juszkiewicz, Maciej Wajda, Klaudia Tarabasz

## Inspiration
There is a recent trend in the running community: setting the training to be within a certain 'zone'.

**What is a zone?** It's the intensity level of your activity measured by your heart rate. It's unique for everyone and closely tied to ones personal fitness level. However, the five-zone system describes the same physiological effort levels for everyone.

Zone 1 (Recovery): 68 to 73% of Max Heart Rate (HR), Purpose: Active recovery

Zone 2 (Endurance): 73 to 80% of Max HR,  Purpose: Build aerobic base

Zone 3 (Tempo): 80 to 87% of Max HR, Purpose: Improve steady-state pacing and aerobic strength

Zone 4 (Threshold): 87 to 93% of Max HR, Purpose: Increase stamina

Zone 5 (VO2 Max): 93 to 100% of Max HR, Purpose: Improve peak power and top-end speed

**Why is accidentally switching zones bad for you?** It can reduce the effectiveness of your training. For example, running within the zone 3 means running with the highest possible speed that is still sustainable for longer runs. Going into higher zone, even for a second, inevitably means: shortness of breath, broken pace and after just a few steps: slowing down.

The ability to guarantee staying within a certain zone would be invaluable for runners. Sadly, modern apps can only detect change of zone after it happened.

But what if... **we could reliably predict change of zone before it happens**? And warn the user early enough to avoid it?

## What it does
Our app allows user to choose target zone for the run. Then, the app starts to monitor user performance through sensors in the wearable. With the help of AI algorithms, we can predict when the user is on track to change zones and warn them (through vibrations and visual signals). It's a preventive measure that gives user opportunity (on average 30 seconds) to adjust their pace.

## How we built it
Project is divided into three main areas:
1. Wearable UI
2. Wearable Application Logic
3. Server infrastructure for training our models

Firstly we provided wearable application's pages, that allows to enhance your training experience. It contains several screens, where configuration and measuring BPM and pace is offered. This is complemented by use of the application logic, for storing the data from the trainings, calculating predicted Heart Zone for the next time interval, letting the user know about it and finally retrieving the gathered data and sending it to the server. There (server) we are using our trained model to adjust the parameters for the Kalman Filter used on the watch for predicting expected Heart Zone.

## Challenges we ran into
- Unfavorable weather to create real world data (had no volunteers for a necessary 2h jogging session). That meant we had to use mock data to emulate responses from the AI model.
- Problems with implementing persistent data storage and touching our server's endpoint over HTTP with measured data after the training.

## Accomplishments that we're proud of
With general AI-hype happening right now, everyone has seen many "AI implementation fails". Some areas are simply not suited for AI and get outperformed easily by traditional solutions. Our idea however, is a textbook example of well defined problem of pattern recognition. And that's exact kind of problem, where AI can shine.
It is also for all of us a first time meeting with this specific environment and even developing mobile solutions, especially for wearables. Although we encountered some problems along the way, we still managed to deliver functioning Proof of Concept.

## What we learned
First of all using new OS and how building solutions for mobiles and wearables looks like. Additionally it was an exceptional training for diving swiftly into documentation of entirely new environment and prototyping.

## What's next for Watch.ai
Going this one last step further from PoC to fully functional solution and getting to know from the running junkies how do they like it!