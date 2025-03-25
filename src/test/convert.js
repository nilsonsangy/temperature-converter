const convert = require('../convert')
var expect  = require("chai").expect;

describe('Temperature converter', () => {

    it('Should correctly convert Fahrenheit to Celsius', (done) => {

      const resultado = convert.fahrenheitCelsius(131);

      expect(resultado).to.equal(55);
      done();
  
    });

    it('Should correctly convert Celsius to Fahrenheit', (done) => {

      const resultado = convert.celsiusFahrenheit(55);

      expect(resultado).to.equal(131);
      done();
  
    });    
  
  });