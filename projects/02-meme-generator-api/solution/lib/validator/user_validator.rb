require "json"
require "./lib/errors/user_error"
require "./lib/errors/user_body_error"
require "./lib/errors/user_input_error"

class UserValidator
  class << self
    def validate(params)
      raise UserBodyError.new("'user' not found in body!") unless params["user"]
      raise UserBodyError.new("'user.username' not found in body!") unless params["user"]["username"]
      raise UserBodyError.new("'user.password' not found in body!") unless params["user"]["password"]

      errors = {}
      errors[:username_blank] = true if params["user"]["username"].empty?
      errors[:password_blank] = true if params["user"]["password"].empty?

      err = error_messages(errors)
      raise UserInputError.new(err) unless err.nil?
    end

    private

    def error_messages(errors)
      messages = []
      messages.push(message("Username is blank!")) if errors[:username_blank]
      messages.push(message("Password is blank!")) if errors[:password_blank]

      # TODO: do not return json, let the validator user to use the results as he pleases
      { "errors" => messages }.to_json unless messages.empty? 
    end

    def message(content)
      { "message" => content }
    end
  end
end
