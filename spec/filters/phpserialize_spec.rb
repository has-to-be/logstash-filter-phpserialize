# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/phpserialize"

describe LogStash::Filters::Phpserialize do
  describe "parse Hello World" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
        }
      }
    CONFIG
    end

    sample('s:11:"Hello World";') do
      expect(subject.get('message')).to eq('Hello World')
    end
  end

  describe "parse empty field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
        }
      }
    CONFIG
    end

    sample('') do
      expect(subject.get('message')).to eq('')
    end
  end

  describe "parse non-existing field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          source => "in"
        }
      }
    CONFIG
    end

    sample('') do
      expect(subject.get('message')).to eq('')
      expect(subject.get('tags')).to be_nil
    end
  end

  describe "parse null value" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
        }
      }
    CONFIG
    end

    sample('N;') do
      expect(subject.get('message')).to be_nil
    end
  end

  describe "parse corrupt value" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
        }
      }
    CONFIG
    end

    sample('Hello World') do
      expect(subject.get('message')).to eq('Hello World')
      expect(subject.get('tags')).to include('_phpunserializefailure')
    end
  end

  describe "parse from source field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          source => "in"
        }
      }
    CONFIG
    end

    sample("in" => 'i:42;') do
      expect(subject.get('message')).to eq(42)
    end
  end

  describe "parse into target field" do
    let(:config) do <<-CONFIG
      filter {
        phpserialize {
          target => "php"
        }
      }
    CONFIG
    end

    sample('i:42;') do
      expect(subject).to include('php')
      expect(subject.get('php')).to eq(42)
    end
  end
end
