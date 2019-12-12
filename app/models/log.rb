class Log
  attr_accessor :id
  attr_accessor :created_at
  attr_accessor :status
  attr_accessor :code
  attr_accessor :error_description

  def initialize(id: nil, created_at: nil, status: nil, code: nil, error_description: nil)
    @id = id
    @created_at = created_at
    @status = status
    @code = code
    @error_description = error_description
  end

  # Returns string to be used in storing to file
  def to_row
    "#{id}  #{created_at}  #{status}  #{code}  #{error_description}"
  end

  # Assigns header string to be used in storing to file
  def self.header
    'ID    Created at    Status Code ErrorDescription'
  end
end