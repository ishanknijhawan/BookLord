const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("chats/{docId}/messages/{message}")
    .onCreate(async (snap, context) => {
        console.log("----------------start function--------------------");

        const doc = snap.data();
        //console.log(doc);

        const idFrom = doc.senderId;
        const idTo = doc.receiverId;
        const contentMessage = doc.message;

        // Get push token user to (receive)
        console.log("coming here for querySnapshot");
        let querySnapshot = await admin
            .firestore()
            .collection("users")
            .where("uid", "==", idTo)
            .get();
        console.log(querySnapshot);

        console.log("coming here for querySnapshot2");
        querySnapshot.forEach(async (userTo) => {
            console.log(`Found user to: ${userTo.data().name}`);
            if (userTo.data().token !== "") {
                // Get info user from (sent)
                let querySnapshot2 = await admin
                    .firestore()
                    .collection("users")
                    .where("uid", "==", idFrom)
                    .get();
                console.log(querySnapshot2);

                querySnapshot2.forEach(async (userFrom) => {
                    console.log(`Found user from: ${userFrom.data().name}`);
                    const payload = {
                        notification: {
                            title: `You have a message from "${
                                userFrom.data().name
                            }"`,
                            body: contentMessage,
                            badge: "1",
                            sound: "default",
                            clickAction: "FLUTTER_NOTIFICATION_CLICK",
                        },
                    };
                    // Let push to the target device
                    let response = await admin
                        .messaging()
                        .sendToDevice(userTo.data().token, payload);

                    console.log("Successfully sent message:", response);
                    return response;
                });
            }
        });
    });
