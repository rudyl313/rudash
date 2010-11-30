(function($) {
  $(function(){

    $(".heading_container").click(function(){
      $(".recurring_entry_controls").slideUp();
      $(".recurring_entry_controls",$(this).parent()).slideDown();
    });

  });
})(jQuery);