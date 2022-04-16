require "./lib/errors/user_body_error"

class UserValidator
  def self.validate(params)
    raise UserBodyError.new("'user' not found in body!") unless params["user"]
    raise UserBodyError.new("'user.username' not found in body!") unless params["user"]["username"]
    raise UserBodyError.new("'user.password' not found in body!") unless params["user"]["password"]
  end
end
