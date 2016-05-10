var assert = chai.assert;
describe('Array', function() {
  describe('#indexOf()', function () {
    before(function(){
      $('#mocha').append('<or-language-selector />')
    });

    it('should return -1 when the value is not present', function () {
      var el = $('or-language-selector')
      assert.equal(1, el.length);

      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});