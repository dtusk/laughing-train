class Backup
  attr_accessor :id
  attr_accessor :created_at
  attr_accessor :status
  attr_accessor :size
  attr_accessor :database

  def initialize(id: nil, created_at: nil, status: nil, size: nil, database: nil)
    @id = id
    @created_at = created_at
    @status = status
    @size = size
    @database = database
  end
end