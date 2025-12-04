class TasksController < ApplicationController
        # Skip CSRF for API endpoints
    skip_before_action :verify_authenticity_token
    #to check user authorization: token validation
    before_action :authorize_request
    before_action :set_project
    before_action :set_task, only: [:show, :update, :destroy]
    before_action -> { require_same_tenant(@task) }, only: [:show, :update, :destroy] #block cross tenant access


      # RBAC filters
    before_action :can_create_task?, only: [:create]
    before_action :can_update_task?, only: [:update]
    before_action :can_destroy_task?, only: [:destroy]


      # GET /projects/:project_id/tasks
    def index
        page = params[:page] ||1
        per_page = params[:per_page] ||20
        tasks = Task.active.where(tenant_id: current_user.tenant_id, project_id: params[:project_id]).paginate(page,per_page)
        if tasks.any?
            render json: tasks, status: :ok
        else 
            render json: {message: "No Tasks added to this project"}, status: :ok
        end
    end

    
    # GET /projects/:project_id/tasks/:id
    def show
        if @task
            render json: @task, status: :ok
        else
            render json: {message: "Tasks  doesnt exist"}, status: :not_found
        end
    end

     # POST /projects/:project_id/tasks
    def create
        task = Task.new(task_params)
        task.project_id = params[:project_id]
        task.tenant_id = current_user.tenant_id   
        task.created_by_id = current_user.id   

        if Task.exists?(title: task.title,tenant_id: current_user.tenant_id, project_id: params[:project_id])
            render json: {message: "Task already exists"}, status: :unprocessable_entity
        elsif task.save
            render json: {message: "Task created successfully", task: task }, status: :created
        else
            render json: {message: "Error creating the task" , error: task.errors},status: :unprocessable_entity 
        end
    end

    # PUT/PATCH /projects/:project_id/tasks/:id
    def update
        update_data = task_params
        if task_params[:status] == "done" && @task.status != "done"
            update_data = update_data.merge(completed_at: Time.current)
        end
        if @task.update(update_data)
            render json: { message: "Task updated", task: @task }, status: :ok
        else
            render json: { message: "Update failed", errors: @task.errors }, status: :unprocessable_entity
        end
    end

    # DELETE /projects/:project_id/tasks/:id
    def destroy
        if @task.update(deleted_at: Time.current)
            render json: { message: "Task archived (soft deleted)" }, status: :ok
        else
            render json: { message: "Failed to delete Task", errors: @task.errors }, status: :unprocessable_entity
        end
    end



    private
    #to check projectid exists for the right tenant before loading tasks
    def set_project
        @project = Project.active.where(tenant_id: current_user.tenant_id).find_by(id: params[:project_id])
        render json: { error: "Project not found" }, status: :not_found unless @project
    end


    def set_task
        @task = Task.active.where(tenant_id: current_user.tenant_id,project_id: params[:project_id]).find_by(id: params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description, :target_date, :status, :priority,:assignee_id,:due_date)#changeee!
    end

     
    # RBAC filters
    def can_create_task?
        unless current_user.admin? || current_user.manager?
            render json: { error: "Forbidden: cannot create task" }, status: :forbidden
        end
    end

    def can_update_task?
        if current_user.admin? || current_user.manager?
            return true
        elsif current_user.contributor?
            unless @task&.assignee_id == current_user.id
                render json: { error: "Forbidden: cannot update this task" }, status: :forbidden
            end
        else
            render json: { error: "Forbidden: cannot update task" }, status: :forbidden
        end
    end

    def can_destroy_task?
        unless current_user.admin?
            render json: { error: "Forbidden: cannot delete task" }, status: :forbidden
        end
    end
end

