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
      revert: 'invalid',
      refreshPositions: true
    });

    $(".date_group").droppable({
      drop : function(e,ui){
        var dropped_date = $(this).attr("data-date");
        var $dragged_item = $(ui.draggable);
        var $dragged_group = $dragged_item.parent().parent();
        var dragged_date = $dragged_group.attr("data-date");
        var dragged_id = $dragged_item.attr("data-id");
        var $dropped_group = $(".entry_list",$(this));
        $dropped_group.slideUp();
        $(".entry_list",$("[data-date='" + dragged_date  + "']")).slideUp();
        $.ajax({
          url : $(ui.draggable).attr("data-update-path"),
          type : 'PUT',
          data : {
            entry : {
              due_date : dropped_date
            }
          },
          success : function(data,x,y){
            $dropped_group.html(data);
            $dropped_group.slideDown();
            $(".entry",$dropped_group).draggable({
              revert: 'invalid',
              refreshPositions: true
            });
            $dragged_item.remove();
            $(".entry_list",$dragged_group).slideDown();
          }
        });
      }
    });

  });
})(jQuery);