(function($) {
  $(function(){

    $(".date_container").click(function(){
      $(".entry_controls").slideUp();
      $(".entry_controls",$(this).parent()).slideDown();
    });

    $(".submit_new_entry").click(function(e){
      e.preventDefault();
      var $group = $(this).parent().parent();
      var datestr = $group.attr("data-date");
      $.ajax({
        url : $(this).attr("data-path"),
        type : 'POST',
        data : {
          entry : {
            due_time : $("#time_field_" + datestr).val(),
            due_date : datestr,
            content : $("#content_field_" + datestr).val()
          }
        },
        success : function(data,x,y){
          $(".entry_controls").slideUp();
          $(".entry_list",$group).slideUp();
          $(".entry_list",$group).html(data);
          $(".entry_list",$group).slideDown();
          $("#time_field_" + datestr).val("");
          $("#content_field_" + datestr).val("");
        }
      });
    });

    $(".entry").draggable({
      //revert: 'invalid',
      revert : true,
      refreshPositions: true
      //helper : 'clone',
    });

    $(".date_group").droppable({
      drop : function(e,ui){
        var dropped_date = $(this).attr("data-date");
        var dragged_date = $(ui.draggable).parent().parent().attr("data-date");
        var dragged_id = $(ui.draggable).attr("data-id");
        alert("Dragged " + dragged_id + " from " + dragged_date + " to " + dropped_date);
      }
    });

  });
})(jQuery);