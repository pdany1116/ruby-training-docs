require "sqlite3"
require "time"
require "fileutils"
require "./lib/db/user"
require "./lib/db/token"

class DB
  DB_PATH = "./db.sqlite3"
  USERS_TABLE = "Users"
  USER_TOKENS_TABLE = "UserTokens"

  def initialize
    @db = SQLite3::Database.new(DB_PATH)
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{USERS_TABLE} (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT,
        unique (username)
      );
    SQL
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{USER_TOKENS_TABLE} (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        token TEXT,
        FOREIGN KEY(userId) REFERENCES Users(id)
      );
    SQL
  end

  private_class_method :new

  def user_by_username(username)
    rows = @db.execute <<-SQL
      SELECT * 
      FROM #{USERS_TABLE} 
      WHERE username = '#{username}';
    SQL

    User.new(rows[0][0], rows[0][1], rows[0][2])
  end

  def tokens_by_user_id(user_id)
    rows = @db.execute <<-SQL
      SELECT * 
      FROM #{USER_TOKENS_TABLE} 
      WHERE userId = '#{user_id}';
    SQL

    rows.map { |row| Token.new(row[0], row[1], row[2]) }
  end

  def insert_user(user)
    @db.execute <<-SQL
      INSERT INTO #{USERS_TABLE} (username, password)
      VALUES (
        '#{user.username}',
        '#{user.password}'
      );
    SQL

    @db.last_insert_row_id
  end

  def insert_token(token)
    @db.execute <<-SQL
      INSERT INTO #{USER_TOKENS_TABLE} (userId, token)
      VALUES (
        '#{token.userId}',
        '#{token.token}'
      );
    SQL

    @db.last_insert_row_id
  end

  def clear_all
    @db.execute <<-SQL
      DELETE FROM #{USERS_TABLE};
    SQL
    @db.execute <<-SQL
      DELETE FROM #{USER_TOKENS_TABLE};
    SQL
  end

  class << self  
    def create
      @instance ||= new
    end
  end
end
