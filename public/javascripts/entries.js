(function($) {
  $(function(){
    $(".date_container").click(function(){
      // Figure out how to properly move a div
      $("#add_entry_controls").hide();
      $(".entry_controls",$(this).parent()).append($("#add_entry_controls"));
      $("#add_entry_controls").show();
    });
    $("#submit_new_entry").click(function(e){
      e.preventDefault();
      var $group = $(this).parent().parent().parent();
      $.ajax({
        url : $(this).attr("data-path"),
        type : 'POST',
        data : {
          entry : {
            due_time : $("#entry_time_field").val(),
            due_date : $group.attr("data-date"),
            content : $("#entry_content_field").val()
          }
        },
        success : function(data,x,y){
          $("#add_entry_controls").slideUp();
          $(".entry_list",$group).slideUp();
          $(".entry_list",$group).html(data);
          $(".entry_list",$group).slideDown();
          $("#entry_content_field").val("");
          $("#entry_time_field").val("");
        }
      });
    });
  });
})(jQuery);