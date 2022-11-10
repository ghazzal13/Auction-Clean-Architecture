var paypal = require('paypal-rest-sdk');
var express = require('express');
var app = express();

paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': 'AR7Z1dliexGVg8n8iykkAciHD4pnVyJmQYxzFJ1xRqwlzZXHLa2SBJ8_8QvMPV8W2BumTgdIe-70tnEx',
    'client_secret': 'EGgigqtFLi_on5dXfx2IHGnJq7oKWaTm3RLq3_5OMbmrNlEctpcxgNzqMqTp5MINndBV61J1F6QODRvF'
});


app.get('/pay', (req, res) => {

    var create_payment_json = {
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"
        },
        "redirect_urls": {
            "return_url": "http://localhost:8000/success",
            "cancel_url": "http://cancel.url"
        },
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": "item",
                    "sku": "item",
                    "price": "500.00",
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": "500.00"
            },
            "description": "This is the payment description."
        }]
    };


    paypal.payment.create(create_payment_json, (error, payment) => {
        if (error) {
            throw error;
        } else {
            console.log("Create Payment Response");
            console.log(payment);
            for (var index = 0; index < payment.links.length; index++) {

                if (payment.links[index].rel === 'approval_url') {
                    res.redirect(payment.links[index].href);
                    console.log(payment.links[index].href);
                }
            }
        }
    });

})

app.get('/success', (req, res) => {
    var execute_payment_json = {
        "payer_id": req.query.PayerID,
        "transactions": [{
            "amount": {
                "currency": "USD",
                "total": "500.00"
            }
        }]
    };

    var paymentId = req.query.paymentId;

    paypal.payment.execute(paymentId, execute_payment_json, function (error, payment) {
        if (error) {
            console.log(error.response);
            throw error;
        } else {
            console.log("Get Payment Response");
            console.log(JSON.stringify(payment));
        }
    });
})

app.listen(8000, '127.0.0.1', (req, res) => {
    console.log('server startef')
})