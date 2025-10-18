-- Initialize Temperature Converter Database
CREATE TABLE IF NOT EXISTS conversions (
    id SERIAL PRIMARY KEY,
    original_value DECIMAL(10,2) NOT NULL,
    converted_value DECIMAL(10,2) NOT NULL,
    conversion_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for better performance on timestamp queries
CREATE INDEX IF NOT EXISTS idx_conversions_timestamp ON conversions(timestamp DESC);

-- Insert some sample data for testing
INSERT INTO conversions (original_value, converted_value, conversion_type) VALUES
(0, 32, 'Celsius to Fahrenheit'),
(100, 212, 'Celsius to Fahrenheit'),
(32, 0, 'Fahrenheit to Celsius'),
(212, 100, 'Fahrenheit to Celsius');

-- Display success message
SELECT 'Database initialized successfully!' as message;