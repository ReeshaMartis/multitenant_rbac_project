require 'jwt'

class JwtService
    ACCESS_EXPIRY = 15.minutes.from_now
    REFRESH_EXPIRY =  7.days.from_now

    def self.encode_access(payload)
        encode(payload,ACCESS_EXPIRY)
    end
        
    def self.encode_refresh(payload)
        encode(payload,REFRESH_EXPIRY)
    end

    def self.encode(payload,exp)
        payload[:exp] = exp.to_i #converting to integer seconds
        JWT.encode(payload,secret_key) #default takes 'HS256'
    end

    def self.decode(token)
        puts "decoding with #{ENV['JWT_SECRET_KEY']}"
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