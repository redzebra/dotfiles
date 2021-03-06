Pry.editor = 'vi'

Pry.prompt = [
  proc {|obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} > "},
  proc {|obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} * "}
]

Pry.config.ls.separator = "\n" # new lines between methods
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

begin
  require 'awesome_print'
  Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}
rescue LoadError => err
  puts "gem install awesome_print  # <-- highly recommended"
end

if RUBY_VERSION >= '1.9'
  CodeRay.scan("example", :ruby).term # just to load necessary files

  TERM_TOKEN_COLORS = {
    :attribute_name => '33',
    :attribute_value => '31',
    :binary => '1;35',
    :char => {
      :self => '36', :delimiter => '34'
    },
    :class => '1;35',
    :class_variable => '36',
    :color => '32',
    :comment => '37',
    :complex => '34',
    :constant => ['34', '4'],
    :decoration => '35',
    :definition => '1;32',
    :directive => ['32', '4'],
    :doc => '46',
    :doctype => '1;30',
    :doc_string => ['31', '4'],
    :entity => '33',
    :error => ['1;33', '41'],
    :exception => '1;31',
    :float => '1;35',
    :function => '1;34',
    :global_variable => '42',
    :hex => '1;36',
    :include => '33',
    :integer => '1;34',
    :key => '35',
    :label => '1;15',
    :local_variable => '33',
    :octal => '1;35',
    :operator_name => '1;29',
    :predefined_constant => '1;36',
    :predefined_type => '1;30',
    :predefined => ['4', '1;34'],
    :preprocessor => '36',
    :pseudo_class => '34',
    :regexp => {
      :self => '31',
      :content => '31',
      :delimiter => '1;29',
      :modifier => '35',
      :function => '1;29'
    },
    :reserved => '1;31',
    :shell => {
      :self => '42',
      :content => '1;29',
      :delimiter => '37',
    },
    :string => {
      :self => '36',
      :modifier => '1;32',
      :escape => '1;36',
      :delimiter => '1;32',
    },
    :symbol => '1;31',
    :tag => '34',
    :type => '1;34',
    :value => '36',
    :variable => '34',

    :insert => '42',
    :delete => '41',
    :change => '44',
    :head => '45'
  }

  module CodeRay
    module Encoders
      class Terminal < Encoder
        # override old colors
        TERM_TOKEN_COLORS.each_pair do |key, value|
          TOKEN_COLORS[key] = value
        end
      end
    end
  end
end
