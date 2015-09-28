require_relative 'associatable'
require 'active_support/inflector'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]
      source_options.model_class.where(id: self.send(through_name)
                                               .send(source_options.foreign_key))
                                               .first
    end
  end
end
