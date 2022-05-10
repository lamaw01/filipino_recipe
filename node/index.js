const express = require("express");
const cors = require("cors");
const { v4: uuidv4 } = require('uuid');

const db = require("./config");
const app = express();
app.use(express.json());
app.use(cors(
    {
        origin: "http://192.168.0.15:80",
        methods: ["GET", "POST"],
    }
));

//get all featured recipe limit 3
app.get("/featured", async (req, res) => {
    const snapshot = await db.collection("featured").orderBy("timestamp", "desc").limit(3).get();;
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

//get all recipe sorted by name
app.get("/recipe", async (req, res) => {
    const snapshot = await db.collection("recipe").orderBy("name", "asc").get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

//get new recipe limit 5 with timestamp
app.get("/new", async (req, res) => {
    const snapshot = await db.collection("recipe").orderBy("timestamp", "desc").limit(5).get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

//get categories
app.get("/category", async (req, res) => {
    const snapshot = await db.collection("category").get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

//get recipe with category for random
app.get("/recipe/:category", async (req, res) => {
    const category = req.params.category;
    const snapshot = await db.collection("recipe").where("category", "==", category).get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

//add new recipe
app.post("/add_recipe", async (req, res) => {
    const data = req.body;
    const name = req.body.name;
    if (name == null) {
        res.send({ msg: "parameters not met", status: 400 });
    } else {
        const timestamp = new Date().getTime();;
        await db.collection("recipe").add({ id: uuidv4(), timestamp: timestamp, ...data });
        res.status(201).send({ msg: "added new recipe", status: 201 });
    }
});

//add new featured
app.post("/add_featured", async (req, res) => {
    const data = req.body;
    const name = req.body.name;
    if (name == null) {
        res.send({ msg: "parameters not met", status: 400 });
    } else {
        const timestamp = new Date().getTime();;
        await db.collection("featured").add({ id: uuidv4(), timestamp: timestamp, ...data });
        res.status(201).send({ msg: "added new featured", status: 201 });
    }
});

//error 404
app.all('*', (req, res, next) => {
    const err = new Error('not found');
    err.status = 404;
    next(err);
});

app.use((err, req, res, next) => {
    res.status(err.status || 500)
    res.send({
        error: err.status || 500,
        message: err.message,
    })
});

// var port = process.env.PORT || 80;

app.listen('80', '192.168.0.15', function () {
    console.log("listening on port http://192.168.0.15:80")
})