$(function(){
  $('.tree-toggle').children('ul.tree').toggle(200);

  $('.tree-toggle>span').click(function () {
    $(this).parent().children('ul.tree').toggle(200);
  });
});
