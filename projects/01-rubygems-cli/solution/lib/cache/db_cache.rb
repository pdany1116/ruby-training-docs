require "sqlite3"
require "time"
require "fileutils"

require "./lib/cache/cache_entry"

class DBCache
  DB_PATH = "./cache.sqlite3"
  TABLE_NAME = "RUBYGEMS"
  EXPIRATION_TIME = 48 * 60 * 60

  def initialize
    @db = SQLite3::Database.new(DB_PATH)
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{TABLE_NAME} (
        key VARCHAR(16) PRIMARY KEY,
        value TEXT,
        expires_at DATETIME
      );
    SQL
  end

  private_class_method :new

  def read(key)
    rows = @db.execute <<-SQL
      SELECT * 
      FROM #{TABLE_NAME} 
      WHERE key = '#{key}'
        AND DATETIME('now') < expires_at;
    SQL
    return if rows.nil? or rows.empty?

    # Remove SQL double quotes to recreate original text
    value = rows[0][1].gsub("''", "'")
    expires_at = Time.parse(rows[0][2])

    CacheEntry.new(value, expires_at)
  end

  def write(key, value, expires_at = Time.now + EXPIRATION_TIME)
    # Escape SQL single quotes in text to avoid errors
    value = value.gsub("'", "''")

    @db.execute <<-SQL
      INSERT OR REPLACE INTO #{TABLE_NAME} 
      VALUES (
        '#{key}',
        '#{value}',
        '#{expires_at}'
      );
    SQL
  end

  def clear_all
    @db.execute <<-SQL
      DELETE FROM #{TABLE_NAME};
    SQL
  end

  class << self  
    def create
      @instance ||= new
    end
  end
end
