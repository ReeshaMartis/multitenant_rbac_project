class UsersController < ApplicationController
    # Skip CSRF for API endpoints
    skip_before_action :verify_authenticity_token, only: [:create, :login]

    def index
    end
    
    # post /signup
    def create
        puts "Received user params #{user_params}"
        user = User.new(user_params)
        if user.save
            render json: {message: "User created successfully"}, status: :created
        else
            render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    # post /login
    def login
        user = User.find_by(email: params[:email])
        puts "PARAMS: #{params.inspect}"
        puts "FOUND USER: #{user.inspect}"
        if user 
            if user.authenticate(params[:password])
                puts "PASSWORD MATCHED"
                payload = {
                user_id: user.id,
                tenant_id: user.tenant_id,
                role: user.role
                }
                puts "payload : #{payload.inspect}"
                token = JwtService.encode(payload)
                render json: { token: token }, status: :ok
            else
                puts "PASSWORD DID NOT MATCH"
                render json: { error: "Invalid email or password" }, status: :unauthorized
            end
        else
            puts "USER NOT FOUND"
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end
    private

    def user_params
        puts "received user parmas #{params.inspect}"
        params.require(:user).permit(:email, :password,:tenant_id)
    end

end
