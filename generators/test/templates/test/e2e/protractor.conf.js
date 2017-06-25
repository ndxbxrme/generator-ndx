exports.config = {
  seleniumAddress: 'http://localhost:4444/wd/hub',
  specs: ['e2e.js'],
  capabilities: {
    'browserName': 'chrome',
    'chromeOptions': {
      'args': ['no-sandbox']
    }
  },
  jasmineNodeOpts: {
    defaultTimeoutInterval: 9000000 
  }
}