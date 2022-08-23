class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL

    DB[:conn].execute(sql)
    DB[:conn].execute("PRAGMA table_info(songs)") #confirm table info
  end

  #inserting Data into a table with the #save Method => persist song instances to DB
  def save
    #heredoc
    sql = <<-SQL 
      INSERT INTO songs (name, album) 
      VALUES (?, ?)
    SQL

    #insert the song
    DB[:conn].execute(sql, self.name, self.album)

    #get the song ID from the DB and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    #return ruby instance
    self
  end

  #create a new Song instance and save it by wrapping code above
  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end
