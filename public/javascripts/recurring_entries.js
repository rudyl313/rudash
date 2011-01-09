(function($) {
  $(function(){

    $(".heading_container").click(function(){
      var $parent = $(this).parent();
      $(".recurring_entry_controls").not($(".recurring_entry_controls",$parent)).slideUp();
      $(".recurring_entry_controls",$parent).slideToggle();
    });

    function create_recurring_entry(rentry,successfn){
      var create_path = $("#hidden").attr("data-create-path");
      $.ajax({
        url : create_path,
        type : 'POST',
        data : {
          recurring_entry : rentry
        },
        success : successfn
      });
    }

    function destroy_handler() {
      var $this = $(this);
      var id = $this.attr("data-id");
      var user_id = $("#helper").attr("data-user-id");
      $.ajax({
        url : "/users/" + user_id + "/recurring_entries/" + id,
        type : 'DELETE',
        data : {
          recurring_entry : { id : id}
        },
        success : function(x,y,data){ $this.parent().remove();  }
      });
    }

    $(".submit_new_daily").click(function(){
      var time = $("#time_field_daily").val();
      var content = $("#content_field_daily").val();
      var recurring_entry = {
        period : "daily",
        due_time : time,
        content : content
      };
      $(".recurring_entry_controls",$("#daily_group")).slideUp();
      $(".recurring_entry_list",$("#daily_group")).slideUp();
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#daily_group")).html(data);
        $(".recurring_entry_list",$("#daily_group")).slideDown();
        $(".destroy_rentry",$("#daily_group")).click(destroy_handler);
      });
    });

    $(".submit_new_weekdaily").click(function(){
      var time = $("#time_field_weekdaily").val();
      var content = $("#content_field_weekdaily").val();
      var recurring_entry = {
        period : "weekdaily",
        due_time : time,
        content : content
      };
      $(".recurring_entry_controls",$("#weekdaily_group")).slideUp();
      $(".recurring_entry_list",$("#weekdaily_group")).slideUp();
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#weekdaily_group")).html(data);
        $(".recurring_entry_list",$("#weekdaily_group")).slideDown();
        $(".destroy_rentry",$("#weekdaily_group")).click(destroy_handler);
      });
    });

    $(".submit_new_weekly").click(function(){
      var time = $("#time_field_weekly").val();
      var content = $("#content_field_weekly").val();
      var day = $("#day_field_weekly option:selected").attr("value");
      var recurring_entry = {
        period : "weekly",
        due_time : time,
        content : content,
        wday : day
      };
      $(".recurring_entry_controls",$("#weekly_group")).slideUp();
      $(".recurring_entry_list",$("#weekly_group")).slideUp();
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#weekly_group")).html(data);
        $(".recurring_entry_list",$("#weekly_group")).slideDown();
        $(".destroy_rentry",$("#weekly_group")).click(destroy_handler);
      });
    });

    $(".submit_new_monthly").click(function(){
      var time = $("#time_field_monthly").val();
      var content = $("#content_field_monthly").val();
      var day = $("#day_field_monthly option:selected").attr("value");
      var recurring_entry = {
        period : "monthly",
        due_time : time,
        content : content,
        mday : day
      };
      $(".recurring_entry_controls",$("#monthly_group")).slideUp();
      $(".recurring_entry_list",$("#monthly_group")).slideUp();
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#monthly_group")).html(data);
        $(".recurring_entry_list",$("#monthly_group")).slideDown();
        $(".destroy_rentry",$("#monthly_group")).click(destroy_handler);
      });
    });

    $(".submit_new_yearly").click(function(){
      var time = $("#time_field_yearly").val();
      var content = $("#content_field_yearly").val();
      var day = $("#day_field_yearly option:selected").attr("value");
      var month = $("#month_field_yearly option:selected").attr("value");
      var recurring_entry = {
        period : "yearly",
        due_time : time,
        content : content,
        mday : day,
        month : month
      };
      $(".recurring_entry_controls",$("#yearly_group")).slideUp();
      $(".recurring_entry_list",$("#yearly_group")).slideUp();
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#yearly_group")).html(data);
        $(".recurring_entry_list",$("#yearly_group")).slideDown();
        $(".destroy_rentry",$("#yearly_group")).click(destroy_handler);
      });
    });

    $(".destroy_rentry").click(destroy_handler);

  });
})(jQuery);