require 'bloc_record/utility'
require 'bloc_record/schema'
require 'bloc_record/persistence'
require 'bloc_record/selection'
require 'bloc_record/connection'
require 'bloc_record/collection'
 
module BlocRecord
  class Base
    include Persistence
    extend Selection
    extend Schema
    extend Connection
 
    def initialize(options={})
      options = BlocRecord::Utility.convert_keys(options)
      
      self.class.columns.each do |col|
        self.class.send(:attr_accessor, col)
        self.instance_variable_set("@#{col}", options[col])
      end
    end

    def method_missing(method_name, *args, &block)
      method = method_name.to_s
      if method.include?('find_by')
        first_part = method[0..6]
        second_part = method[8..-1]
        attribute = second_part.to_sym
        find_by(attribute, args[0])
      elsif method.include?('update')
        first_part = method[0..5]
        second_part = method[7..-1]
        attribute = second_part.to_sym
        update_attribute(attribute, args[0])
      else
        super
      end
    end
  end
end