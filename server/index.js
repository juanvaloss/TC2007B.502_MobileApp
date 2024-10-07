const express = require("express");
const bodyParser = require("body-parser");
var cors = require("cors");

const app = express();
const port = 3000;

//Routes
const userRoutes = require("./routes/userRoutes")

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
// testing

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});

app.use("/users",userRoutes)