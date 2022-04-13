class User
  attr_reader :id, :username, :password

  def initialize(id = nil, username, password)
    @id = id
    @username = username
    @password = password
  end
end