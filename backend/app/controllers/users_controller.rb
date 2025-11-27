class UsersController < ApplicationController

    # post /signup
    def create
        user = User.new(user_params)
        if user.save
            render json: {message: "User created successfully"}, status: :created
        else
            render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
        emd
    end

    # post /login
    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            payload = {
                user_id: user.id,
                tenant_id: user.tenant_id,
                role: user.role
            }
            token = JWTService.encode(payload)

            render json: {token: token}, status: :ok
        else
            render json: {error:"Invalid email or password"}, status: :unauthorized
        end
    end
    private

    def user_params
        params.require(:user).permit(:email, :password, :role, :tenant_id)
    end

end
