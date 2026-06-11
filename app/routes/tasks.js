const express = require("express");
const { pool } = require("../db");

const router = express.Router();

router.get("/", async (req, res, next) => {
  try {
    const [tasks] = await pool.query("SELECT * FROM tasks ORDER BY created_at DESC");
    res.render("index", { tasks });
  } catch (error) {
    next(error);
  }
});

router.post("/tasks", async (req, res, next) => {
  const title = req.body.title?.trim();
  const description = req.body.description?.trim() || null;

  if (!title) {
    return res.status(400).send("A task title is required.");
  }

  try {
    await pool.execute("INSERT INTO tasks (title, description) VALUES (?, ?)", [title, description]);
    res.redirect("/");
  } catch (error) {
    next(error);
  }
});

router.get("/tasks/:id/edit", async (req, res, next) => {
  try {
    const [tasks] = await pool.execute("SELECT * FROM tasks WHERE id = ?", [req.params.id]);
    if (tasks.length === 0) {
      return res.status(404).send("Task not found.");
    }
    res.render("edit", { task: tasks[0] });
  } catch (error) {
    next(error);
  }
});

router.post("/tasks/:id/edit", async (req, res, next) => {
  const title = req.body.title?.trim();
  const description = req.body.description?.trim() || null;

  if (!title) {
    return res.status(400).send("A task title is required.");
  }

  try {
    await pool.execute("UPDATE tasks SET title = ?, description = ? WHERE id = ?", [
      title,
      description,
      req.params.id
    ]);
    res.redirect("/");
  } catch (error) {
    next(error);
  }
});

router.post("/tasks/:id/toggle", async (req, res, next) => {
  try {
    await pool.execute("UPDATE tasks SET completed = NOT completed WHERE id = ?", [req.params.id]);
    res.redirect("/");
  } catch (error) {
    next(error);
  }
});

router.post("/tasks/:id/delete", async (req, res, next) => {
  try {
    await pool.execute("DELETE FROM tasks WHERE id = ?", [req.params.id]);
    res.redirect("/");
  } catch (error) {
    next(error);
  }
});

module.exports = router;
