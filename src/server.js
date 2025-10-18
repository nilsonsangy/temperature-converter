const express = require('express');
const os = require('os')
const app = express();
const converter = require('./convert')
const bodyParser = require('body-parser');
const config = require('./config/system-life');
const path = require('path');
const pkgversion = require('./package.json').version;
const database = require('./database');

// Initialize database
database.initializeDatabase().catch(err => {
    console.error('Error initializing database:', err);
});


app.use(config.middlewares.healthMid);
app.use('/', config.routers);
app.use(bodyParser.urlencoded({ extended: false }))
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.get('/fahrenheit/:value/celsius', async (req, res) => {

    let value = req.params.value;
    let celsius = converter.fahrenheitCelsius(value);
    
    // Save conversion to database
    try {
        await database.saveConversion(value, celsius, 'Fahrenheit to Celsius');
    } catch (error) {
        console.error('Error saving conversion:', error);
    }
    
    res.json({ "celsius": celsius, "machine": os.hostname(), pkgversion});
});

app.get('/celsius/:value/fahrenheit', async (req, res) => {

    let value = req.params.value;
    let fahrenheit = converter.celsiusFahrenheit(value);
    
    // Save conversion to database
    try {
        await database.saveConversion(value, fahrenheit, 'Celsius to Fahrenheit');
    } catch (error) {
        console.error('Error saving conversion:', error);
    }
    
    res.json({ "fahrenheit": fahrenheit, "machine": os.hostname(), pkgversion});
});

app.get('/', async (req, res) => {
    // Get latest conversions from database
    let latestConversions = [];
    try {
        latestConversions = await database.getLatestConversions();
    } catch (error) {
        console.error('Error fetching conversions:', error);
    }

    res.render('index',{
        convertedValue: '', 
        machine: os.hostname(), 
        pkgversion,
        latestConversions: latestConversions
    });
});

app.post('/', async (req, res) => {
    let result = '';
    let conversionType = '';

    if (req.body.valueRef) {
        if (req.body.selectTemp == 1) {
            result = converter.celsiusFahrenheit(req.body.valueRef);
            conversionType = 'Celsius to Fahrenheit';
        } else {
            result = converter.fahrenheitCelsius(req.body.valueRef);
            conversionType = 'Fahrenheit to Celsius';
        }
        
        // Save conversion to database
        try {
            await database.saveConversion(req.body.valueRef, result, conversionType);
        } catch (error) {
            console.error('Error saving conversion:', error);
        }
    }
    
    // Get latest conversions from database
    let latestConversions = [];
    try {
        latestConversions = await database.getLatestConversions();
    } catch (error) {
        console.error('Error fetching conversions:', error);
    }
    
    res.render('index', {
        convertedValue: result, 
        "machine": os.hostname(), 
        pkgversion,
        latestConversions: latestConversions
    });
 });

app.listen(8080, () => {
    console.log("Server running on port 8080");
});
