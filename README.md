# CrazyBullet

A simple game for Digicre Minigame 2017

## How To Build

### Requirements

* Dartlang
  * latest
* firebase-tool
  * node.js
    * latest
  * `npm install -g firebase-tools`

### Credentials

* Update `web/main.dart` file with your Firebase Projcet's credentials:

```dart
initializeApp(
      apiKey: "TODO",
      authDomain: "TODO",
      databaseURL: "TODO",
      storageBucket: "TODO");
```

### Run app

```
$firebase deploy
```