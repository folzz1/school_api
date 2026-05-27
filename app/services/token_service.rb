require "digest"

class TokenService
  SECRET_SALT = ENV.fetch("SECRET_SALT", "secret_salt")

  def self.generate(user_id)
    Digest::SHA256.hexdigest("#{user_id}#{SECRET_SALT}")
  end

  def self.valid?(user_id, token)
    token.present? && token == generate(user_id)
  end
end