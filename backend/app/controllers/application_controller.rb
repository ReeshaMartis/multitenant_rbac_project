class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    puts "Headers: #{request.headers.to_h.select{|k,v| k.include?('AUTH')}}"
    puts "Authorization header: #{request.headers['Authorization']}"
    puts "HTTP_AUTHORIZATION header: #{request.headers['HTTP_AUTHORIZATION']}"

    header = request.headers['Authorization'] || request.headers['HTTP_AUTHORIZATION']
    token = header.split(' ')&.last if header

    if token.blank?
      return render json: { error: 'Missing token' }, status: :unauthorized
    end
    begin
      decoded = JwtService.decode(token)  
      puts "decoded string: #{decoded.inspect}"
      if decoded.nil?
        return render json: { error: 'Invalid token' }, status: :unauthorized
      end
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def require_same_tenant(resource)
  return render json: { error: "Resource not found" }, status: :not_found unless resource
  return render json: { error: "Access denied: tenant mismatch" }, status: :forbidden if resource.tenant_id != current_user.tenant_id
end


end 


