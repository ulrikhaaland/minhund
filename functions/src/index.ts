import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as firebase_tools from "firebase-tools";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

exports.recursiveDelete = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .https.onCall((data, context) => {
    // Only allow admin users to execute this function.
    if (!(context.auth && context.auth.token)) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Must be an administrative user to initiate delete."
      );
    }

    const path = data.path;
    const type = data.type;

    console.log(
      `User ${context.auth.uid} has requested to delete path ${path}`
    );

    // Run a recursive delete on the given document or collection path.
    // The 'token' must be set in the functions config, and can be generated
    // at the command line by running 'firebase login:ci'.
    return firebase_tools.firestore
      .delete(`${type}/${context.auth.uid}/${path}`, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true
      })
      .then(() => {
        return {
          path: path
        };
      });
  });

export const sendNotificationToDevice = (
  data: FirebaseFirestore.DocumentData,
  fcm: string
): any => {
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: data.title,
      body: data.body,
      // icon: 'your-icon-url',
      click_action: "FLUTTER_NOTIFICATION_CLICK"
    },

    data: {
      title: data.title,
      body: data.body,
      note: data.note !== null ? data.note : "",
      eventId: data.eventId
    }
  };
  return messaging.sendToDevice(fcm, payload);
};

export const scheduledFunctionPlainEnglish = functions.pubsub
  .schedule("5 10 * * *")
  .onRun(() => {
    const compareDateString = admin.firestore.Timestamp.fromDate(new Date())
      .toDate()
      .toISOString()
      .split("T")[0];

    return db
      .collection("reminders")
      .where("timestampAsIso", "==", compareDateString)
      .get()
      .then(qSnap => {
        qSnap.docs.forEach(doc => {
          const reminder = doc.data();
          return db
            .doc(`users/${reminder.userId}`)
            .get()
            .then(userDoc => {
              const fcm = userDoc.data().fcm;
              if (fcm !== null) {
                sendNotificationToDevice(reminder, fcm);
              }
              return doc.ref.delete().then(promise => {
                return promise;
              });
            });
        });
        return;
      });
  });
