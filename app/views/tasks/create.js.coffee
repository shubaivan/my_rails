$('#tasks').prepend("<%= j(render @task) %>")
$('form')[0].reset()
