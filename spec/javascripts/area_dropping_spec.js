require('/javascripts/jquery.js')
require('/javascripts/application.js')

describe('evergreen', function() {
  it("should work", function(){
    $('#test').append('<h1 id="added">New Stuff</h1>');
    expect($('#test h1#added').length).toEqual(1);
  });
});
