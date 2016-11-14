$('#tasks[data-type!="done"]').prepend("<%= j(render @task) %>")
$('form')[0].reset()
