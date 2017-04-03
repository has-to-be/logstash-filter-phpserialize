# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/phpserialize"

describe LogStash::Filters::Phpserialize do
  describe "parse Hello World" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          target => "php"
        }
      }
    CONFIG
    end

    sample("message" => 's:11:"Hello World";') do
      expect(subject).to include('php')
      expect(subject.get('php')).to eq('Hello World')
    end
  end

  describe "parse from source field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          source => "php_in"
          target => "php_out"
        }
      }
    CONFIG
    end

    sample("php_in" => 'i:42;') do
      expect(subject).to include('php_out')
      expect(subject.get('php_out')).to eq(42)
    end
  end
end
