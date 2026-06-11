const mysql = require("mysql2/promise");

const requiredVariables = ["DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME"];
const missingVariables = requiredVariables.filter((name) => !process.env[name]);

if (missingVariables.length > 0) {
  throw new Error(`Missing required environment variables: ${missingVariables.join(", ")}`);
}

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: Number(process.env.DB_PORT || 3306),
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

async function initializeDatabase() {
  await pool.execute(`
    CREATE TABLE IF NOT EXISTS tasks (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      title VARCHAR(255) NOT NULL,
      description TEXT,
      completed BOOLEAN NOT NULL DEFAULT FALSE,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id)
    )
  `);
}

module.exports = { pool, initializeDatabase };
