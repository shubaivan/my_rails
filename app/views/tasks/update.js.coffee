$("#task_<%= @task.id %>").replaceWith('<%= j(render @task) %>')
<% if params.dig(:task, :done) %>
$("#tasks:not([data-type='']) #task_<%= @task.id %>").slideUp()
<% end %>
