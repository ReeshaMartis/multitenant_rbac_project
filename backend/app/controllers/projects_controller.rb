class ProjectsController < ApplicationController
    # Skip CSRF for API endpoints
    skip_before_action :verify_authenticity_token
    #to check user authorization: token validation
    before_action :authorize_request

    before_action :set_project, only: [:show, :update, :destroy] #loads projects of the specific tenant only
    before_action -> { require_same_tenant(@project) }, only: [:show, :update, :destroy] #block cross tenant access

    # RBAC filters
    before_action :can_see_projects_index?, only: [:index]
    before_action :can_see_project?, only: [:show]
    before_action :can_create_project?, only: [:create]
    before_action :can_update_project?, only: [:update]
    before_action :can_destroy_project?, only: [:destroy]

    
    # GET /projects
   # GET /projects?page=1&per_page=2
    def index
        # @projects is already set by can_see_projects_index? (tenant + RBAC)

        #apply filters
        @projects = @projects.by_status(params[:status])
                       .by_name(params[:name])
                       .by_creator(params[:created_by])
                       .target_after(params[:target_after])
                       .target_before(params[:target_before])
                       .created_after(params[:created_after])
                       .created_before(params[:created_before])

        #pagination
        page = params[:page] ||1
        per_page = params[:per_page] ||20
        @projects = @projects.paginate(page,per_page)
        if @projects.any?
            render json: @projects, status: :ok
        else 
            render json: {message: "No Projects added"}, status: :ok
        end
    end

    # GET /projects/:id
    def show
        if @project
            render json: @project, status: :ok
        else
            render json: {message: "Project doesnt exist"}, status: :not_found
        end
    end

     # POST /projects
    def create
        project = Project.new(project_params)
        project.tenant_id = current_user.tenant_id   
        project.created_by_id = current_user.id    

        if Project.exists?(name: project.name,tenant_id: current_user.tenant_id)
            render json: {message: "Project already exists"}, status: :unprocessable_entity
        elsif project.save
            render json: {message: "Project created successfully", project: project }, status: :created
        else
            render json: {message: "Error creating the project" , error: project.errors},status: :unprocessable_entity 
        end
    end

    # PUT/PATCH /projects/:id
    def update
        if @project.update(project_params)
            render json: { message: "Project updated", project: @project }, status: :ok
        else
            render json: { message: "Update failed", errors: @project.errors }, status: :unprocessable_entity
        end
    end

    # DELETE /projects/:id
    def destroy
        if @project.tasks.exists?
            render json: { message: "Cannot delete project with tasks" }, status: :forbidden
        else
            if @project.update(deleted_at: Time.current)
                render json: { message: "Project archived (soft deleted)" }, status: :ok
            else
                render json: { message: "Failed to delete project", errors: @project.errors }, status: :unprocessable_entity
            end
        end
    end


    private
    def set_project
        @project = Project.active.where(tenant_id: current_user.tenant_id).find_by(id: params[:id])
    end

    def project_params
        params.require(:project).permit(:name, :description, :target_date, :status)
    end
    
    # RBAC filters
    def can_see_projects_index?
        if current_user.admin? || current_user.manager?
            @projects = Project.active.where(tenant_id: current_user.tenant_id)
        else
            @projects = Project.active.where(tenant_id: current_user.tenant_id, created_by_id: current_user.id)
        end
    end

    def can_see_project?
        if current_user.admin? || current_user.manager?
            return true
        elsif current_user.contributor?
            unless @project.created_by_id == current_user.id
                render json: { error: "Forbidden: cannot view this project" }, status: :forbidden
            end
        else
            render json: { error: "Forbidden: cannot view project" }, status: :forbidden
        end
    end

    def can_create_project?
        unless current_user.admin? || current_user.manager?
            render json: { error: "Forbidden: cannot create project" }, status: :forbidden
        end
    end

    def can_update_project?
        if current_user.admin? || current_user.manager?
            return true
        elsif current_user.contributor?
            unless @project.created_by_id == current_user.id
                render json: { error: "Forbidden: cannot update this project" }, status: :forbidden
            end
        else
            render json: { error: "Forbidden: cannot update project" }, status: :forbidden
        end
    end

    def can_destroy_project?
        unless current_user.admin?
            render json: { error: "Forbidden: cannot delete project" }, status: :forbidden
        end
    end
end