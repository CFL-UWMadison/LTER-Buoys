(function ($) {
  Drupal.behaviors.circle2 = {
    attach: function (context, settings) {

var value1 = Drupal.settings.numdays;
var value2 = Drupal.settings.temps_array[1][1];

window.alert(value2);

    }
  };
})(jQuery);
