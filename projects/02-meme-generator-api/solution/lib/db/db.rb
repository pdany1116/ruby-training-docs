require "sqlite3"
require "time"
require "fileutils"
require "./lib/db/user"

class DB
  DB_PATH = "./db.sqlite3"
  USERS_TABLE = "USERS"

  def initialize
    @db = SQLite3::Database.new(DB_PATH)
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{USERS_TABLE} (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      );
    SQL
  end

  private_class_method :new

  def find(user)
    rows = @db.execute <<-SQL
      SELECT * 
      FROM #{USERS_TABLE} 
      WHERE username = '#{user.username}'
        AND password = '#{user.password}';
    SQL
    return false if rows.nil? or rows.empty?
    
    true
  end

  def insert(user)
    @db.execute <<-SQL
      INSERT INTO #{USERS_TABLE} (username, password)
      VALUES (
        '#{user.username}',
        '#{user.password}'
      );
    SQL
  end

  def clear_all
    @db.execute <<-SQL
      DELETE FROM #{USERS_TABLE};
    SQL
  end

  class << self  
    def create
      @instance ||= new
    end
  end
end