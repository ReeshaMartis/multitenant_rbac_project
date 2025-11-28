# Seed data for 2 tenants, each with users, projects, tasks, and discussion threads
require 'faker'

TENANT_COUNT = 2
PROJECTS_RANGE = (4..6)
TASKS_RANGE = (40..80)
THREADS_RANGE = (10..20)
USER_ROLES = %w[admin manager contributor]

TASK_STATUSES = %i[to_do in_progress blocked done]
THREAD_STATUSES = %i[open responded resolved archived]

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
    end
  end

  # Projects: created only by admin or manager
  project_count = rand(PROJECTS_RANGE)
  projects = []
  project_count.times do |j|
    name = "Project#{j+1}_Tenant#{i+1}"
    projects << Project.find_or_create_by!(name: name, tenant: tenant) do |p|
      p.description = Faker::Lorem.sentence(word_count: 8)
      p.created_by = [users['admin'], users['manager']].sample  # only admin/manager
      p.status = :active
      p.target_date = Date.today + rand(7..90).days
    end
  end

  # Tasks: created only by admin/manager, assignee can be anyone
  task_count = rand(TASKS_RANGE)
  tasks = []
  task_count.times do |k|
    project = projects.sample
    assignee = users.values.sample  # can assign to any user
    created_by = [users['admin'], users['manager']].sample  # only admin/manager
    title = "Task#{k+1}_#{project.name}"
    task = Task.find_or_create_by!(title: title, project: project, tenant: tenant) do |t|
      t.description = Faker::Lorem.sentence(word_count: 10)
      t.assignee = assignee
      t.created_by = created_by
      t.priority = rand(1..5)
      t.due_date = Date.today + rand(1..60).days
      t.status = TASK_STATUSES.sample
    end
    tasks << task
  end

  # Discussion threads: created by any user
  thread_count = rand(THREADS_RANGE)
  thread_count.times do |t|
    task = tasks.sample
    created_by = users.values.sample  # any user
    title = "Thread#{t+1}_#{task.title}"
    DiscussionThread.find_or_create_by!(title: title, task: task, tenant: tenant) do |dt|
      dt.body = Faker::Lorem.paragraph(sentence_count: 3)
      dt.created_by = created_by
      dt.status = THREAD_STATUSES.sample
      dt.project = task.project
    end
  end
end

puts "Seeding complete!"
