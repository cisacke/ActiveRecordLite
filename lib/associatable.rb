require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    Object.const_get(@class_name)
  end

  def table_name
    Object.const_get(@class_name).table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    options[:foreign_key].nil? ? @foreign_key = ("#{name.to_s}_id").to_sym : @foreign_key = options[:foreign_key]
    options[:primary_key].nil? ? @primary_key = :id : @primary_key = options[:primary_key]
    options[:class_name].nil? ? @class_name = name[0].upcase + name[1..-1] : @class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    options[:foreign_key].nil? ? @foreign_key = ("#{self_class_name.downcase}_id").to_sym : @foreign_key = options[:foreign_key]
    options[:primary_key].nil? ? @primary_key = :id : @primary_key = options[:primary_key]
    options[:class_name].nil? ? @class_name = name[0].upcase + name[1..-2] : @class_name = options[:class_name]
  end
end

module Associatable
  def belongs_to(name, options = {})

    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options

    define_method(name) do
      options.model_class.where(:id => self.send(options.foreign_key)).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      options.model_class.where(options.foreign_key => id)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
