import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();

// const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document("reminders/{reminderId}")
  .onCreate(async snapshot => {
    const reminder = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: reminder.title,
        body: reminder.body,
        // icon: 'your-icon-url',
        click_action: "FLUTTER_NOTIFICATION_CLICK"
      },

      data: {
        title: reminder.title,
        body: reminder.body
      }
    };
    return fcm.sendToDevice(reminder.fcm, payload);
  });

export const scheduledFunctionPlainEnglish = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(context => {
    db.collection("reminders")
      .where("timestamp", "==", Date.prototype.getDate)
      .get()
      .then(snapshot => {});
  });
