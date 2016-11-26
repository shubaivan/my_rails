$("#lists").html("<%= escape_javascript(render partial: "lists/lists")%>");
$('form')[0].reset()