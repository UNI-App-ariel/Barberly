// const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const {onDocumentCreated} = require("firebase-functions/firestore");

const admin = require("firebase-admin");
admin.initializeApp();

const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;

/**
 * Formats a date to "HH:mm DD/MM/YYYY" format in UTC.
 * @param {Date} date - The date object to format.
 * @return {string} - The formatted date string.
 */
const formatDate = (date) => {
  return date.toLocaleString("en-GP", {
    timeZone: "Asia/Jerusalem",
    hour: "2-digit",
    minute: "2-digit",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
};

// send notification to OneSignal
async function sendNotification(payload) {
  console.log("Sending notification", payload);

  for (let attempt = 1; attempt <= 3; attempt++) {
    try {
      const response = await fetch("https://api.onesignal.com/notifications", {
        method: "POST",
        headers: {
          "Authorization": `Basic ${ONESIGNAL_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        console.log("Notification sent successfully");
        return await response.json();
      } else {
        console.error(
            "Failed to send notification",
            response.status,
            await response.text(),
        );
      }
    } catch (error) {
      console.error("Error on attempt", attempt, error);
    }
  }
  throw new Error("Failed to send notification after 3 attempts");
}

// notify shop owner of new appointment
const notifyShopOwnerOnAppointment = onDocumentCreated(
    "appointments/{appointmentId}",
    async (snapshot, context) => {
      const appointment = snapshot.data.data();
      const appointmentId = snapshot.id;
      const shopId = appointment.shop_id;
      const customerId = appointment.user_id;

      const appointmentDate = formatDate(appointment.date.toDate());
      logger.info(`New appointment: ${appointmentId} on ${appointmentDate}`);

      // send notification to shop owner
      try {
      // Fetch shop and customer data in parallel
        const shopSnapshot = await admin
            .firestore()
            .collection("barbershops")
            .doc(shopId)
            .get();
        const ownerId = shopSnapshot.data().ownerId;

        const payload = {
          app_id: ONESIGNAL_APP_ID,
          include_aliases: {
            external_id: [ownerId],
          },
          target_channel: "push",
          headings: {
            en: "📅 New Appointment",
          },
          contents: {
            en: `New appointment on ${appointmentDate}`,
          },
          data: {
            type: "appointment",
            id: appointment.id,
            shopId: shopId,
            customerId: customerId,
          },
        };

        // send notification
        await sendNotification(payload);
      } catch (error) {
        logger.error(`Error sending notification to shop owner: ${error}`);
      }
    },
);

// export functions
module.exports = {
  notifyShopOwnerOnAppointment,
};
