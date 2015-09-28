# ActiveRecord Lite

An ORM based on the core features of ActiveRecord. It uses the metaprogramming ability of Ruby to create an extendable SQLObject class, which mimics some of the functionality available with ActiveRecord::Base.

# Features

<!-- Model Objects -->

<!-- Queries -->

<!-- Record.where() -->
```
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

```
<!-- Record.all -->
<!-- Record.find(params[:id]) -->
<!-- Record.save -->

<!-- Associations -->

<!-- has many -->
<!-- belongs_to -->
<!-- has_one_through -->
