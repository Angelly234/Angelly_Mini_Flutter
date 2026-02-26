require("dotenv").config()
const express = require("express")
const cors = require("cors")
const app = express()
require("./db")

app.use(express.json())
app.use(cors())

app.use("/api/auth", require("./routes/auth"))
app.use("/api/categories", require("./routes/category"))
app.use("/api/products", require("./routes/product"))

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000")
})