$('a#aboutLink').fancybox({
  autoDimensions: false,
  width: 500,
  overlayOpacity: 0.9,
  overlayColor: '#369',
  onStart: function() {
             $('div#about').show();
           },
  onCleanup: function() {
               $('div#about').parent().hide();
             }
});

$('a#contactLink').click(function(e) {
  e.preventDefault();
  feedback_widget.show();
});
