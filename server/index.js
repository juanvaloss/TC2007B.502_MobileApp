const express = require("express");
const bodyParser = require("body-parser");
var cors = require("cors");

const app = express();
const port = 3000;

//Routes
const userRoutes = require("./routes/userRoutes");
const centerRoutes = require("./routes/centerRoutes");
const adminRoutes = require("./routes/adminsRoutes");
const applicationRoutes = require("./routes/applicationsRoutes");
const donationRoutes = require("./routes/donationsRoutes");
const tfaRoutes = require("./routes/tfasRoutes");
const loginRoutes = require("./routes/loginRoutes");
const collectionRoutes = require("./routes/collectionRoutes");


app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.listen(port, () => {
    console.log(`http://localhost:${port}`);
});

app.use("/users",userRoutes)
app.use("/centers",centerRoutes)
app.use("/admins",adminRoutes)
app.use("/applications",applicationRoutes)
app.use("/donations",donationRoutes)
app.use("/tfa", tfaRoutes)
app.use("/login", loginRoutes)
app.use("/collections", collectionRoutes)

