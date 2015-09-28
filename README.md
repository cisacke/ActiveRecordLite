# ActiveRecord Lite

An ORM based on the core features of ActiveRecord. It uses the metaprogramming ability of Ruby to create an extendable SQLObject class, which mimics some of the functionality available with ActiveRecord::Base.

# Core Features

<!-- Model Objects -->

## Queries

### Record.where()
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

### Record.insert()
```
def insert
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end
```

### Record.update()
```
def update
    set = self.class.columns.map{ |column| "#{column} = ?"}.join(", ")
    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
      #{self.class.table_name}
    SET
      #{set}
    WHERE
      id = ?
    SQL
  end
```

## Associations

### has many, belongs_to

### has_one_through
```
  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      source_options.model_class.where(id: self.send(through_name)
                                                .send(source_options.foreign_key))
                                                .first
    end
  end
```
