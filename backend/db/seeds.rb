
# Seed data for 2 tenants, each with users, projects, tasks, and discussion threads
require 'faker'

TENANT_COUNT = 2
PROJECTS_RANGE = (4..6)
TASKS_RANGE = (40..80)
THREADS_RANGE = (10..20)
USER_ROLES = %w[admin manager contributor]

puts "Seeding tenants, users, projects, tasks, and discussion threads..."

TENANT_COUNT.times do |i|
	tenant = Tenant.find_or_create_by!(name: "Tenant#{i+1}")

	# Create users
	users = {}
	USER_ROLES.each do |role|
		users[role] = User.find_or_create_by!(
			email: "#{role}@tenant#{i+1}.com",
			tenant: tenant
		) do |u|
			u.password = 'password123'
			u.role = role
			u.name = "#{role.capitalize} User Tenant#{i+1}"
		end
	end

	# Create projects
	project_count = rand(PROJECTS_RANGE)
	projects = []
	project_count.times do |j|
		projects << Project.create!(
			name: "Project#{j+1}_Tenant#{i+1}",
			tenant: tenant,
			created_by: users.values.sample
		)
	end

	# Create tasks
	task_count = rand(TASKS_RANGE)
	tasks = []
	task_count.times do |k|
		project = projects.sample
		assignee = users.values.sample
		created_by = users.values.sample
		tasks << Task.create!(
			title: "Task#{k+1}_#{project.name}",
			tenant: tenant,
			project: project,
			assignee: assignee,
			created_by: created_by,
			status: Task.status.values.sample
		)
	end

	# Create discussion threads
	thread_count = rand(THREADS_RANGE)
	thread_count.times do |t|
		task = tasks.sample
		created_by = users.values.sample
		DiscussionThread.create!(
			title: "Thread#{t+1}_#{task.title}",
			tenant: tenant,
			task: task,
			created_by: created_by,
			status: DiscussionThread.status.values.sample
		)
	end
end

puts "Seeding complete!"
