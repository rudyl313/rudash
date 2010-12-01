(function($) {
  $(function(){

    $(".heading_container").click(function(){
      $(".recurring_entry_controls").slideUp();
      $(".recurring_entry_controls",$(this).parent()).slideDown();
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
        alert("success");
      });
    });

    $(".submit_new_weekly").click(function(){
      alert("woot");
    });

    $(".submit_new_monthly").click(function(){
      alert("woot");
    });

    $(".submit_new_yearly").click(function(){
      alert("woot");
    });

  });
})(jQuery);