const { Pool } = require('pg');

// PostgreSQL connection pool configuration
const pool = new Pool({
  user: process.env.DB_USERNAME || 'user',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_DATABASE || 'temperature_db',
  password: process.env.DB_PASSWORD || 'password123',
  port: process.env.DB_PORT || 5432,
});

// Function to initialize the database
async function initializeDatabase() {
  try {
    // Create conversions table if it doesn't exist
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS conversions (
        id SERIAL PRIMARY KEY,
        original_value DECIMAL(10,2) NOT NULL,
        converted_value DECIMAL(10,2) NOT NULL,
        conversion_type VARCHAR(50) NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `;
    
    await pool.query(createTableQuery);
    console.log('✅ Conversions table created/verified successfully');
  } catch (error) {
    console.error('❌ Error initializing database:', error);
    throw error;
  }
}

// Function to save a conversion
async function saveConversion(originalValue, convertedValue, conversionType) {
  try {
    const query = `
      INSERT INTO conversions (original_value, converted_value, conversion_type)
      VALUES ($1, $2, $3)
      RETURNING *;
    `;
    
    const result = await pool.query(query, [originalValue, convertedValue, conversionType]);
    return result.rows[0];
  } catch (error) {
    console.error('❌ Error saving conversion:', error);
    throw error;
  }
}

// Function to get the last 10 conversions
async function getLatestConversions() {
  try {
    const query = `
      SELECT original_value, converted_value, conversion_type, timestamp
      FROM conversions
      ORDER BY timestamp DESC
      LIMIT 10;
    `;
    
    const result = await pool.query(query);
    return result.rows;
  } catch (error) {
    console.error('❌ Error fetching conversions:', error);
    throw error;
  }
}

// Function to test connection
async function testConnection() {
  try {
    const result = await pool.query('SELECT NOW()');
    console.log('✅ PostgreSQL connection established:', result.rows[0].now);
    return true;
  } catch (error) {
    console.error('❌ Error connecting to PostgreSQL:', error);
    return false;
  }
}

module.exports = {
  pool,
  initializeDatabase,
  saveConversion,
  getLatestConversions,
  testConnection
};