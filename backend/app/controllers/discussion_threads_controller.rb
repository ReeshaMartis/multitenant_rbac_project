class DiscussionThreadsController < ApplicationController
# Skip CSRF for API endpoints
    skip_before_action :verify_authenticity_token
    #to check user authorization: token validation
    before_action :authorize_request
    before_action :set_project
    before_action :set_task
    before_action :set_discussion_thread, only: [:show, :update]
    before_action -> { require_same_tenant(@discussion_thread) }, only: [:show, :update, :destroy] #block cross tenant access


      # RBAC filters
    before_action :can_create_discussion_thread?, only: [:create]
    before_action :can_update_discussion_thread?, only: [:update]
    # before_action :can_destroy_discussion_thread?, only: [:destroy]


      # GET /projects/:project_id/tasks/:task_id/discussion_threads
    def index
        discussion_threads = DiscussionThread.where(tenant_id: current_user.tenant_id, project_id: params[:project_id], task_id: params[:task_id])
        if discussion_threads.any?
            render json: discussion_threads, status: :ok
        else 
            render json: {message: "No discussion_threads added to this project"}, status: :ok
        end
    end

    
    # GET /projects/:project_id/tasks/:task_id/discussion_threads/:id
    def show
        if @discussion_thread
            # render json: @discussion_thread, status: :ok
            render json: @discussion_thread.as_json(include: [:replies, :attachments]), status: :ok
        else
            render json: {message: "discussion_threads  doesnt exist"}, status: :not_found
        end
    end

     # POST /projects/:project_id/discussion_threads
    def create
        discussion_thread = DiscussionThread.new(discussion_thread_params)
        discussion_thread.project_id = params[:project_id]
        discussion_thread.task_id = params[:task_id]
        discussion_thread.tenant_id = current_user.tenant_id   
        discussion_thread.created_by_id = current_user.id   

        if DiscussionThread.exists?(title: discussion_thread.title,tenant_id: current_user.tenant_id, project_id: params[:project_id], task_id: params[:task_id])
            render json: {message: "discussion_thread already exists"}, status: :unprocessable_entity
        elsif discussion_thread.save
            render json: {message: "discussion_thread created successfully", discussion_thread: discussion_thread }, status: :created
        else
            render json: {message: "Error creating the discussion_thread" , error: discussion_thread.errors},status: :unprocessable_entity 
        end
    end

    # PUT/PATCH /projects/:project_id/tasks/:task_id/discussion_threads/:id
    def update
        if @discussion_thread.update(discussion_thread_params)
            render json: { message: "discussion_thread updated", discussion_thread: @discussion_thread }, status: :ok
        else
            render json: { message: "Update failed", errors: @discussion_thread.errors }, status: :unprocessable_entity
        end
    end

    # DELETE /projects/:project_id/tasks/:task_id/discussion_threads/:id
    # def destroy
    # end



    private
    #to check projectid exists for the right tenant before loading discussion_threads
    def set_project
        @project = Project.active.where(tenant_id: current_user.tenant_id).find_by(id: params[:project_id])
        render json: { error: "Project not found" }, status: :not_found unless @project
    end

    def set_task
        @task = Task.active.where(tenant_id: current_user.tenant_id, project_id:  @project.id).find_by(id: params[:task_id])
        render json: { error: "Task not found" }, status: :not_found unless @task
    end

    def set_discussion_thread
        @discussion_thread = DiscussionThread.where(tenant_id: current_user.tenant_id, project_id: @project.id, task_id: @task.id).find_by(id: params[:id])
    end

    def discussion_thread_params
        params.require(:discussion_thread).permit(:title, :body, :status)
    end

     
    # RBAC filters
    def can_create_discussion_thread?
        unless current_user.admin? || current_user.manager?
            render json: { error: "Forbidden: cannot create discussion_thread" }, status: :forbidden
        end
    end

    def can_update_discussion_thread?
        if current_user.admin? || current_user.manager?
            return true
        elsif current_user.contributor?
            unless @discussion_thread.created_by_id == current_user.id
                render json: { error: "Forbidden: cannot update this discussion_thread" }, status: :forbidden
            end
        else
            render json: { error: "Forbidden: cannot update discussion_thread" }, status: :forbidden
        end
    end

    # def can_destroy_discussion_thread?
    #     unless current_user.admin?
    #         render json: { error: "Forbidden: cannot delete discussion_thread" }, status: :forbidden
    #     end
    # end
end

