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

    sample('s:11:"Hello World";') do
      expect(subject).to include('php')
      expect(subject.get('php')).to eq('Hello World')
    end
  end

  describe "parse empty field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          target => "php"
        }
      }
    CONFIG
    end

    sample('') do
      expect(subject).not_to include('php')
      expect(subject.get('tags')).to include('_phpunserializefailure')
    end
  end

  describe "parse non-existing field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          source => "in"
          target => "php"
        }
      }
    CONFIG
    end

    sample('') do
      expect(subject).not_to include('php')
      expect(subject.get('tags')).to be_nil
    end
  end

  describe "parse null value" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          target => "php"
        }
      }
    CONFIG
    end

    sample('N;') do
      expect(subject).not_to include('php')
      expect(subject.get('tags')).to be_nil
    end
  end

  describe "parse from source field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          source => "in"
          target => "php"
        }
      }
    CONFIG
    end

    sample("in" => 'i:42;') do
      expect(subject).to include('php')
      expect(subject.get('php')).to eq(42)
    end
  end
end
