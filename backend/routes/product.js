const express = require("express")
const router = express.Router()
const sql = require("mssql")

// CREATE PRODUCT
router.post("/", async (req, res) => {
  const { name, description, price, image_url, category_id } = req.body

  await sql.query`
    INSERT INTO Products (name, description, price, image_url, category_id)
    VALUES (${name}, ${description}, ${price}, ${image_url}, ${category_id})
  `

  res.json({ message: "Product created" })
})

// GET PRODUCTS (PAGINATION + SEARCH + SORT + FILTER)
router.get("/", async (req, res) => {
  const page = parseInt(req.query.page) || 1
  const limit = 20
  const offset = (page - 1) * limit

  const search = req.query.search || ""
  const sort = req.query.sort || "name"
  const category = req.query.category || ""

  let query = `
    SELECT * FROM Products
    WHERE name LIKE '%${search}%'
  `

  if (category) {
    query += ` AND category_id = ${category}`
  }

  query += ` ORDER BY ${sort}
             OFFSET ${offset} ROWS
             FETCH NEXT ${limit} ROWS ONLY`

  const result = await sql.query(query)
  res.json(result.recordset)
})

module.exports = router
