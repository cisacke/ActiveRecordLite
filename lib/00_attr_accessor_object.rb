class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      define_method(name) do
        self.instance_variable_get(:"@#{name}")
      end
    end

    names.each do |name|
      define_method("#{name}=") do |new_name|
        self.instance_variable_set(:"@#{name}", new_name)
      end
    end


  end

  my_attr_accessor :x, :y
end
