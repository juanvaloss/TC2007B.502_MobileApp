const express = require("express");
const bodyParser = require("body-parser");
var cors = require("cors");

const app = express();
const port = 3000;

//Routes
const userRoutes = require("./routes/userRoutes")
const centerRoutes = require("./routes/centerRoutes")

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});

app.use("/users",userRoutes)
app.use("/centers",centerRoutes)