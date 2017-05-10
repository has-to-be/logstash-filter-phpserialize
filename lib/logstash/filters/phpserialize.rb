# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

require "php_serialize"

# This filter will decode phpserialized values
class LogStash::Filters::Phpserialize < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   phpserialize {
  #     source => "php_serialized_field"
  #     target => "php_unserialized_field"
  #   }
  # }
  #
  config_name "phpserialize"
  
  config :source, :validate => :string, :default => "message"
  config :target, :validate => :string
  config :tag_on_failure, :validate => :array, :default => ["_phpunserializefailure"]

  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)
    source = event.get(@source)
    return if source.nil?

    begin
      data = PHP.unserialize(source)
      if data
        event.set(@target, data)
      end
    rescue StandardError
      @tag_on_failure.each {|tag| event.tag(tag)}
      return
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Phpserialize
