# Chat Flutter Firebase

<p align="center">
  <a href="https://flutter.dev">
   <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter" height="30" width="100"/>
  </a>
  <a href="https://firebase.google.com/?gad_source=1&gclid=CjwKCAiAnpy9BhAkEiwA-P8N4rNWWo9B7nFbuJ_S4ZEnDEtjkQLSwIM7wCUnlR3Kgfmbu7EpKgpEIhoCJt0QAvD_BwE&gclsrc=aw.ds&hl=en">
    <img src="https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black" alt="Firebase" height="30" width="100"/>
  </a>
</p>


A real-time chat application built with Flutter and Firebase, featuring instant messaging, friend management, group chats, and push notifications.

This project was implemented to be used alongside the https://github.com/RafaelGasparoto/chat-notification project, a node server that create a Firebase cloud function to push notifications.

## Features

- **Real-time Messaging**: Send and receive messages instantly
- **Friend Management**: Add and manage friends
- **Group Chats**: Create and participate in group conversations
- **Push Notifications**: Receive notifications for new messages
- **User Authentication**: Secure login and registration

## Prerequisites

Before starting, ensure you have installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (SDK ^3.6.0)
- [Firebase CLI](https://firebase.google.com/docs/cli) 
- [Node.js](https://nodejs.org/) version 20.10 (for notification server)

## Project Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/chat_flutter_firebase.git
cd chat_flutter_firebase
```

2. Install and configure firebase tools:
```bash
npm install -g firebase-tools
firebase login
```

3. Install flutter_fire to setup and integrate the Firebase services into Flutter project:
```bash
dart pub global activate flutterfire_cli
flutter_fire configure
```
Now the project is set up and ready to use.
