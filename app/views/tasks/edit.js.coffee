task = $('#task_<%= params[:id] %>')
task.html('<%= j(render "form") %>')
task.find('input').focus()
