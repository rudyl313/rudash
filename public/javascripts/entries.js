(function($) {
  $(function(){

    function complete_task(){
      var entry = $(this).parent();
      var update_path = entry.attr("data-update-path");
      $.ajax({
        url : update_path,
        type : 'PUT',
        data : {
          entry : {
            completed_at : "now"
          }
        },
        success : function(data,x,y){
          entry.remove();
        }
      });
    }

    var draggable_options = {
      revert: 'invalid',
      refreshPositions: true,
      zIndex: 10000,
      start : function(e,ui){
        $(this).css("color", "#FFB300");
      },
      stop : function(e,ui){
        $(this).css("color","black");
      }
    };

    var droppable_options = {
      drop : function(e,ui) {
        if ($(this).hasClass("entry")) {
          var $dropped_group = $(this).parent().parent();
          var after_target = $(this).attr("data-id");
        } else {
          var $dropped_group = $(this).parent();
          var after_target = "first";
        }
        var $dragged_item = $(ui.draggable);
        var $dragged_group = $dragged_item.parent().parent();
        var dragged_date = $dragged_group.attr("data-date");
        var dragged_id = $dragged_item.attr("data-id");
        var $dropped_list = $(".entry_list",$dropped_group);
        var $dragged_list = $(".entry_list",$("[data-date='" +
                                              dragged_date  + "']"));
        var dropped_date = $dropped_group.attr("data-date");
        $dropped_list.slideUp();
        $dragged_list.slideUp();
        $.ajax({
          url : $dragged_item.attr("data-update-path"),
          type : 'PUT',
          data : {
            after : after_target,
            entry : {
              due_date : dropped_date
            }
          },
          success : function(data,x,y){
            $dropped_list.html(data);
            $dropped_list.slideDown();
            $(".entry",$dropped_list).draggable(draggable_options);
            $(".entry",$dropped_list).droppable(droppable_options);
            $(".entry_button",$dropped_list).click(complete_task);
            $dragged_item.remove();
            $dragged_list.slideDown();
          }
        });
      }
    };

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
          $(".entry",$group).draggable(draggable_options);
          $(".entry",$group).droppable(droppable_options);
          $(".entry_button",$group).click(complete_task);
          $(".entry_list",$group).slideDown();
          $("#time_field_" + datestr).val("");
          $("#content_field_" + datestr).val("");
        }
      });
    });

    $(".entry_button").click(complete_task);
    $(".entry").draggable(draggable_options);
    $(".entry").droppable(droppable_options);
    $(".date_container").droppable(droppable_options);

  });
})(jQuery);