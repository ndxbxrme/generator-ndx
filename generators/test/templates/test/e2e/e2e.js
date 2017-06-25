describe('my first test', function() {
  it('should do something', function() {
    browser.get('/');
    expect(browser.getTitle()).toBe('<%= appName %>');
  });
});