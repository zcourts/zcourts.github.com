(function ($) {
  //var $window = $(window), $body = $('body');
  var $nav_a = $('#nav').find('a');
  $nav_a.on('click', function () {
    if ($(this).attr('href').split('#').length > 1) {
      $('html, body').animate({
        scrollTop: $('#' + $(this).attr('href').split('#')[1]).offset().top
      }, 2000);
    }
  });
})(jQuery);