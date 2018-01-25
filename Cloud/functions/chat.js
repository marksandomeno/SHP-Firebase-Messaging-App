const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment');

exports.sendChatNotificationOnCreate = (event) => {

    const val = event.data.val();
    if (val === null || val.id || val.error) return null;

    const receiver = val.toId;
    const sender = val.fromId;
    const message = val.text;
    const senderName = val.fromName;

    var messageBody = 'from ' + senderName;

    admin.database().ref(`/users/${receiver}`)
            .once('value')
            .then(function (snapshot) {
                var tokens = [];
                var token = snapshot.child("deviceToken").val();
                tokens.push(token);

                let payload = {
                    notification: {
                        title: messageBody,
                        sound: 'default',
                        badge: '0',
                        'type': 'c'
                    }
                };
                return admin.messaging().sendToDevice(tokens, payload);
    });

};