require 'jwt'

class JwtService

    def self.encode(payload,exp = 24.hours.from_now)
        payload[:exp] = exp.to_i #converting to integer seconds
        JWT.encode(payload,secret_key) #default takes 'HS256'
    end

    def self.decode(token)
        decoded = JWT.decode(token,secret_key,true,algorithm: 'HS256')
        decoded[0]
    rescue JWT::DecodeError
        nil #if token invalid
    end

    private

    #get secret key from env variable
    def self.secret_key
        ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key
    end
end