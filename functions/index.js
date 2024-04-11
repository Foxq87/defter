/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */



const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onCreateActivityFeedItem = functions.firestore
.document('/notifications/{userId}/userNotifications/{activityFeedItem}')
.onCreate(async (snapshot,context)=>{
    console.log('Activity Feed Item Created',snapshot.data());

    const userId = context.params.userId;

    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();

    const notificationToken = doc.data()
    .notificationToken;
    const createdActivityFeedItem = snapshot.data();

    if (notificationToken) {
        //send notification
        sendNotification(notificationToken,createdActivityFeedItem);
    }else {
        console.log("no token for user, cannot send notification");
    }

    function sendNotification(notificationToken,activityFeedItem) {
        let body;
        switch (activityFeedItem.type) {
            case "comment":
                body = `${activityFeedItem.content}`
                break;
            case "like":
                body = `${activityFeedItem.content}`
                break;
            case "follow":
                body = `${activityFeedItem.content}`
                break;
            case "message":
                body = `${activityFeedItem.content}`
                break;
            default:                    
                break;
        }
        const message = {
            notification: { body },
            token: notificationToken,
            data: { recipient: userId }
        };

        admin
            .messaging()
            .send(message)
            .then(response => {

            console.log("Successfully sent message",response);
        })
        .catch(error=>{
            console.log("Error sending message",error)
        });
    }
});