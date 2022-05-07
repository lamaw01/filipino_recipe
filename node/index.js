const express = require("express");
const cors = require("cors");

//firebase config
const db = require("./config");
const featured = db.collection("featured");
const dessert = db.collection("dessert");
const chicken = db.collection("chicken");

const app = express();
app.use(express.json());
app.use(cors(
    {
        origin: "http://127.0.0.1:3000",
        methods: ["GET", "POST"],
    }
));

//featured
app.get("/featured", async (req, res) => {
    const snapshot = await featured.get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

app.post("/create_featured", async (req, res) => {
    const data = req.body;
    const name = req.body.name;
    if (name == null) {
        res.send({ msg: "parameters not met", status: 400 });
    } else {
        await featured.add(data);
        res.send({ msg: "added new featured", status: 201, data: data });
    }

});

//dessert
app.get("/dessert", async (req, res) => {
    const snapshot = await dessert.get();
    const list = snapshot.docs.map((doc) => doc.data());
    res.status(200).send(list);
});

app.post("/create_dessert", async (req, res) => {
    const data = req.body;
    const name = req.body.name;
    if (name == null) {
        res.send({ msg: "parameters not met", status: 400 });
    } else {
        await dessert.add(data);
        res.send({ msg: "success", status: 201, data: data });
    }

});

//chicken
app.post("/create_chicken", async (req, res) => {
    const data = req.body;
    await chicken.add(data);
    res.send({ msg: "success", status: 201 });
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

var port = process.env.PORT || 3000;

app.listen(port, function () {
    console.log("listening on port htts://localhost/3000")
})