require 'active_support/core_ext/class/attribute_accessors'

module Labelized
  class LabelList < Array
    cattr_accessor :delimiter
    self.delimiter = ','

    attr_accessor :owner

    def initialize(*args)
      add(*args)
    end
  
    ##
    # Returns a new LabelList using the given string.
    #
    # LabelList.delimiter can be used to customize how labels in the string are delimited
    #
    # Example:
    #   LabelList.from("One , Two,  Three") # ["One", "Two", "Three"]
    def self.from(string)
      glue   = delimiter.ends_with?(" ") ? delimiter : "#{delimiter} "
      string = string.join(glue) if string.respond_to?(:join)

      new.tap do |tag_list|
        string = string.to_s.dup

        # Parse the quoted labels
        string.gsub!(/(\A|#{delimiter})\s*"(.*?)"\s*(#{delimiter}\s*|\z)/) { tag_list << $2; $3 }
        string.gsub!(/(\A|#{delimiter})\s*'(.*?)'\s*(#{delimiter}\s*|\z)/) { tag_list << $2; $3 }

        tag_list.add(string.split(delimiter))
      end
    end

    ##
    # Add labels to the list. Duplicate or blank labels will be ignored.
    # Use the <tt>:parse</tt> option to add an unparsed label string.
    #
    # Example:
    #   list.add("Fun", "Happy")
    #   list.add("Fun, Happy", :parse => true)
    def add(*names)
      extract_and_apply_options!(names)
      concat(names)
      clean!
      self
    end

    ##
    # Remove specific labels from the list.
    # Use the <tt>:parse</tt> option to add an unparsed label string.
    #
    # Example:
    #   list.remove("Sad", "Lonely")
    #   list.remove("Sad, Lonely", :parse => true)
    def remove(*names)
      extract_and_apply_options!(names)
      delete_if { |name| names.include?(name) }
      self
    end

    ##
    # Transform the list into a label string suitable for edting in a form.
    # The labels are joined with <tt>LabelList.delimiter</tt> and quoted if necessary.
    #
    # Example:
    #   list = LabelList.new("Round", "Square,Cube")
    #   list.to_s # 'Round, "Square,Cube"'
    def to_s
      tags = frozen? ? self.dup : self
      tags.send(:clean!)

      tags.map do |name|
        name.include?(delimiter) ? "\"#{name}\"" : name
      end.join(delimiter.ends_with?(" ") ? delimiter : "#{delimiter} ")
    end

    private
  
    # Remove whitespace, duplicates, and blanks.
    def clean!
      reject!(&:blank?)
      map!(&:strip)
      uniq!
    end

    def extract_and_apply_options!(args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.assert_valid_keys :parse

      if options[:parse]
        args.map! { |a| self.class.from(a) }
      end

      args.flatten!
    end
  end
end
