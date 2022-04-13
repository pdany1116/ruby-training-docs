class Token
  attr_reader :id, :userId, :token

  def initialize(id = nil, userId, token)
    @id = id
    @userId = userId
    @token = token
  end
end
