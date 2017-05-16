require 'sqlite3'
require 'bloc_record/utility'
 
module Schema
  def table
    BlocRecord::Utility.underscore(name)
  end

  # {"id"=>"integer", "name"=>"text", "age"=>"integer"}
  def schema
    unless @schema
      @schema = {}
      connection.table_info(table) do |col|
        @schema[col["name"]] = col["type"]
      end
    end
    @schema
  end

  # ["id", "name", "age"]
  def columns 
    schema.keys
  end

  # ["name", "age"]
  def attributes
    columns - ["id"]
  end

  def count
    connection.execute(<<-SQL)[0][0]
      SELECT COUNT(*) FROM #{table}
    SQL
  end
end