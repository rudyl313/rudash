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

    $(".submit_new_daily").click(function(){
      var time = $("#time_field_daily").val();
      var content = $("#content_field_daily").val();
      var recurring_entry = {
        period : "daily",
        due_time : time,
        content : content
      };
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#daily_group")).html(data);
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
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#weekly_group")).html(data);
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
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#monthly_group")).html(data);
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
      create_recurring_entry(recurring_entry,function(data,x,y){
        $(".recurring_entry_list",$("#yearly_group")).html(data);
      });
    });

    $(".destroy_rentry").click(function(){
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
    });

  });
})(jQuery);