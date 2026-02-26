const express = require("express")
const router = express.Router()
const sql = require("mssql")
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")
require("dotenv").config()

// SIGN UP
router.post("/signup", async (req, res) => {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).json({ message: "Missing fields" })
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10)

    await sql.query`
      INSERT INTO Users (email, password)
      VALUES (${email}, ${hashedPassword})
    `

    res.json({ message: "User registered successfully" })
  } catch (err) {
    res.status(500).json({ message: "Email already exists" })
  }
})

// LOGIN
router.post("/login", async (req, res) => {
  const { email, password } = req.body

  const result = await sql.query`
    SELECT * FROM Users WHERE email = ${email}
  `

  if (result.recordset.length === 0) {
    return res.status(401).json({ message: "Invalid credentials" })
  }

  const user = result.recordset[0]
  const match = await bcrypt.compare(password, user.password)

  if (!match) {
    return res.status(401).json({ message: "Invalid credentials" })
  }

  const token = jwt.sign(
    { id: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: "1h" }
  )

  res.json({ token })
})

module.exports = router