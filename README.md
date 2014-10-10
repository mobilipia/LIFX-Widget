LIFX Widget
===========

Manage your (awesome) [LIFX](http://www.lifx.co "LIFX's website") bulbs, right from notification center.  
Change their colours, turn them off an on, without having to open the main app.

Screenshots
-----------
All screenshots [here](https://github.com/DCMaxxx/LiFX-Widget/tree/master/screenshots, "screenshots")

![Widget screenshot](/screenshots/Widget.png?raw=true "Widget screenshot")

Widget
-----------
Simply press your light name, then pick a colour. Toogle the selected light using the bottom switch.

A greyed out light name means that it couldn't be found on the network.  
If the widget can't detect your light, make sure you're on the same wireless network and the light bulb isn't electrically switched off.

Companion app
-----------
The companion app is used to configure the widget itself. It allows you to :
- Pick your favourite lights to be displayed in the widget (*Since you might own 40 bulbs, display all of them in the notification center wouldn't be the best solution*),
- Nickname a favourite light (*The light won't be renamed, only the name displayed in the widget will be changed*),
- Configure the colours to be displayed in the widget.

Installation
-----------
Unfortunately, Apple doesn't seem to let me publish it on the store.  
It has been rejected twice : the first time because, as they couldn't test the app, they wanted a demo video. Fair enough, I sent them the video, resubmit.  
Twelve days later, it is rejected again. Reason : they can't test it. They want me to send a LIFX bulb to them, for testing. However, I don't really feel like sending them a $100 bulb just for an app validation, so I guess it'll stay on Github.

To install it, you'll need a paid developper account. Follow [the 5th of this tutorial step](http://www.glimsoft.com/06/28/ios-8-today-extension-tutorial/) to configure an app group and enable sharing data between the companion app and the widget.
Then, just build and run the companion scheme on your device. Kill it, then build and run the widget scheme. You should be good to go.

I'd love to make this process simpler - and allow you to install it without a paid account - however, Apple doesn't seem to agree. :sadpanda:.
