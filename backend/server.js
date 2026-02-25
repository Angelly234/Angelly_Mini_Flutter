require("dotenv").config()

const express = require("express")
const cors = require("cors")
const app = express()

const sql = require("./db")

app.use(express.json())
app.use(cors())

app.get("/", (req,res)=>{
  res.send("API Running")
})

app.listen(3000, () => {
  console.log("Server running on port 3000")
})