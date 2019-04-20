# Robeats Mobile App

#### Description:
An application to play music, in the background, on an iOS or Android 
mobile device. This app can be synced with the 
[Robeats Desktop software](http://github.com/robeats-player/Robeats-Desktop "Robeats Desktop software") 
to exchange music over a local network, using the 
[Robeats State Protocol](http://github.com/robeats-player/Robeats-State-Protocol "Robeats State Protocol").



##### Dart & Flutter:
The app is developed using the Flutter framework, for Dart. This was 
viewed as the best option, due to its ability to write native apps for
Android and iOS, once, and for Dart's language. I, personally, looked 
forward to using Dart and Flutter for a project, and this seemed like 
the perfect time.



##### Contributing:
I welcome all contribution, in the form of pull-requests that anybody 
can offer. You must prescribe to the dartfmt guidelines for styling. 
Ensure, if you use Android Studio or another JetBrains IDE, that you 
turn this on. If you do not use an IDE capable of supporting dartfmt,
[take a look here](http://github.com/dart-lang/dart_style/ "take a look here").
Furthermore, ensure your line width is 120! Any PRs with incorrect
styling, or many additions and deletions due to styling, will be
ignored.

###### Side-Note:
I have not included, as of yet, any android or ios files. If you are 
going to build the app, you must run the flutter command to create 
these - as I am using the default package com.example.... so it does not
matter what you use. Eventually, I will include the files, once we use a
package name.



#### To-Do:

- [ ] Begin implementation the Robeats State Protocol.
- [ ] Update the material style, and make the app look a lot better...
- [ ] Implement song syncing.
