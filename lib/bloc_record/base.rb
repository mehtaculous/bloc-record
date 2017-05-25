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
      first_part = method_name[0..6]
      second_part = method_name[8..-1]
      if first_part == "find_by"
        attribute = second_part.to_sym
        find_by(attribute, *args[0])
      else
        super
      end
    end
  end
end