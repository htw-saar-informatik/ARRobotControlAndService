import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { ClientResponse } from 'http';
import { DataSnapshot } from 'firebase-functions/lib/providers/database';
admin.initializeApp()
// tslint:disable-next-line:no-var-keyword


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
 export const abrufDaten = functions.https.onRequest((request, response) => {
    admin.firestore().doc('roboter/1').get()
    .then(snapshot => {
        const data = snapshot.data()
        response.send(data)
    })
    .catch(error => {
        const data = error.data()
        response.send(data)
    })
 });

 export const updateDaten = functions.https.onRequest((request, response) => {
    var name = request.get('name')
    const req: String[] = JSON.parse(request.body);
    const promises = []
    for(let j in req) {
        const e = admin.firestore().doc('config/'+j).set({name:j})
        const p = admin.firestore().doc('roboter/'+name+'/content/' + j).set(req[j])
        promises.push(e)
        promises.push(p)
    }
    const pro = Promise.all(promises)
    .then(citySnapshots => {
        response.status(200).send()
    })
    .catch(error => {
        console.log(error)
        response.status(500).send(error)
    })
    
 });