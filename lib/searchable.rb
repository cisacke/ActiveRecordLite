require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    search_criteria = params.values
    where_line = params.keys.map{ |param| "#{param} = ?"}.join(" AND ")
    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL
    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
