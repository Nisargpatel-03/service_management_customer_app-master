const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendStatusNotification = functions.firestore
  .document("complaints/{complaintId}")
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const oldData = change.before.data();

    if (newData.status === oldData.status) {
      console.log("Status did not change.");
      return null;
    }

    const userId = newData.userId;
    const newStatus = newData.status;

    const userDoc = await admin.firestore()
      .collection("users_id").doc(userId).get();

    if (!userDoc.exists) {
      console.log("User doc not found.");
      return null;
    }

    const fcmToken = userDoc.data().fcmToken;
    if (!fcmToken) {
      console.log("No FCM token found for user:", userId);
      return null;
    }

    const payload = {
      notification: {
        title: "Complaint Status Updated",
        body: `Your complaint "${newData.title}" is now: ${newStatus}`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
      data: {
        complaintId: context.params.complaintId,
        type: "status_update",
      },
    };

    try {
      const response = await admin.messaging().sendToDevice(fcmToken, payload);
      console.log("Successfully sent message:", response);
      return response;
    } catch (error) {
      console.error("Error sending message:", error);
      return null;
    }
  });
