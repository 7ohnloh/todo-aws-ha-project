require("dotenv").config();

const express = require("express");
const path = require("path");
const tasksRouter = require("./routes/tasks");
const { initializeDatabase } = require("./db");

const app = express();
const port = Number(process.env.PORT || 3000);

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "public")));
app.use("/", tasksRouter);

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).render("error", { message: "Something went wrong. Please try again." });
});

async function start() {
  try {
    await initializeDatabase();
    app.listen(port, "0.0.0.0", () => {
      console.log(`To-Do app listening on port ${port}`);
    });
  } catch (error) {
    console.error("Could not connect to the database:", error.message);
    process.exit(1);
  }
}

start();
