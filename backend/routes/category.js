const express = require("express")
const router = express.Router()
const sql = require("mssql")

// CREATE
router.post("/", async (req, res) => {
  const { name, description } = req.body

  await sql.query`
    INSERT INTO Categories (name, description)
    VALUES (${name}, ${description})
  `

  res.json({ message: "Category created" })
})

// READ + SEARCH
router.get("/", async (req, res) => {
  const search = req.query.search || ""

  const result = await sql.query`
    SELECT * FROM Categories
    WHERE name LIKE '%' + ${search} + '%'
  `

  res.json(result.recordset)
})

// UPDATE
router.put("/:id", async (req, res) => {
  const { name, description } = req.body
  const { id } = req.params

  await sql.query`
    UPDATE Categories
    SET name=${name}, description=${description}
    WHERE id=${id}
  `

  res.json({ message: "Category updated" })
})

// DELETE
router.delete("/:id", async (req, res) => {
  const { id } = req.params

  await sql.query`
    DELETE FROM Categories WHERE id=${id}
  `

  res.json({ message: "Category deleted" })
})

module.exports = router