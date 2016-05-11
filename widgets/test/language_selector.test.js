assert = chai.assert

describe('Array', function() {
  describe('#indexOf()', function () {
    before(function(){
      $('body').append('<div id="target">');
    });

    it('should display a select menu when no locales are given', function () {
      var el = $('#target');
      riot.mount(el[0], 'or-language-selector');

      assert.equal(el.find('option').length, 3);
    });

    it('should display buttons when locales are given', function () {
      var el = $('#target');
      riot.mount(el[0], 'or-language-selector', {locales: ['de', 'fr']});
      
      assert.equal(el.find('option').length, 0);
      assert.equal(el.find('.button').length, 1);
    });
  });
});