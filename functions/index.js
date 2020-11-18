const functions = require("firebase-functions");
const admin = require("firebase-admin");

// const admin = require('firebase-admin');
// admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

exports.myFunction = functions.firestore
    .document("chats/{docId}/messages/{message}")
    .onCreate((snapshot, context) => {
        var documentId = context.params.docId;
        const newValue = snapshot.data();

        return admin.messaging().sendToTopic("chat", {
            notification: {
                title: "new message",
                body: newValue.message,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
        });

        // if (
        //     documentId
        //         .toString()
        //         .localCompare(newValue.senderId + newValue.receiverId)
        // ) {
        //     console.log("coming here 1");
        //     return admin.messaging().sendToTopic("chat", {
        //         notification: {
        //             title: "new message",
        //             body: newValue.message,
        //             clickAction: "FLUTTER_NOTIFICATION_CLICK",
        //         },
        //     });
        // } else {
        //     console.log("coming here 2");
        //     return null;
        // }
    });
