const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("messages/{groupId1}/{groupId2}/{message}")
    .onCreate(async (snap, context) => {
        console.log("----------------start function--------------------");

        const doc = snap.data();
        console.log(doc);

        const idFrom = doc.senderId;
        const idTo = doc.receiverId;
        const contentMessage = doc.message;

        // Get push token user to (receive)
        let querySnapshot = await admin
            .firestore()
            .collection("users")
            .where("id", "==", idTo)
            .get();

        querySnapshot.forEach(async (userTo) => {
            console.log(`Found user to: ${userTo.data().name}`);
            if (userTo.data().token !== "") {
                // Get info user from (sent)
                let querySnapshot2 = await admin
                    .firestore()
                    .collection("users")
                    .where("id", "==", idFrom)
                    .get();

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
                        },
                    };
                    // Let push to the target device
                    let response = await admin
                        .messaging()
                        .sendToDevice(userTo.data().token, payload);

                    console.log("Successfully sent message:", response);
                });
            }
        });
    });
