class String
  if RUBY_VERSION >= '1.9'
    def valid_utf8?
      dup.force_encoding('UTF-8').valid_encoding?
    end
  else
    def valid_utf8?
      scan(Regexp.new('[^\x00-\xa0]', nil, 'u')) { |s| s.unpack('U') }
      true
    rescue ArgumentError
      false
    end
  end
end

class Hash
  def self.from_query_string(string)
    query = string.split(/\?/)[-1]
    parts = query.split(/&|=/)
    Hash[*parts]
  end
end

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end
  
  def to_query_string
    self.map { |k| "%s=%s" % [URI.encode(k[0].to_s), URI.encode(k[1].to_s)] }.join('&') unless self.empty?
  end 
end

class Hash
  def to_query_string
    self.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless self.empty?
  end
end

class Object
  def returning(value)
    yield(value)
    value
  end
end

module Kernel
  def __method__(depth = 0)
    caller[depth][/`([^']+)'/, 1]
  end if RUBY_VERSION <= '1.8.7'
  
  def __called_from__
    caller[1][/`([^']+)'/, 1]
  end if RUBY_VERSION > '1.8.7'
  
  def expirable_memoize(reload = false, storage = nil)
    current_method = RUBY_VERSION > '1.8.7' ? __called_from__ : __method__(1)
    storage = "@#{storage || current_method}"
    if reload 
      instance_variable_set(storage, nil)
    else
      if cache = instance_variable_get(storage)
        return cache
      end
    end
    instance_variable_set(storage, yield)
  end

  def require_library_or_gem(library, gem_name = nil)
    if RUBY_VERSION >= '1.9'
      gem(gem_name || library, '>=0') 
    end
    require library
  rescue LoadError => library_not_installed
    begin
      require 'rubygems'
      require library
    rescue LoadError
      raise library_not_installed
    end
  end
end

class Class # :nodoc:
  def cattr_reader(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}
          @@#{sym}
        end

        def #{sym}
          @@#{sym}
        end
      EOS
    end
  end

  def cattr_writer(*syms)
    syms.flatten.each do |sym|
      class_eval(<<-EOS, __FILE__, __LINE__)
        unless defined? @@#{sym}
          @@#{sym} = nil
        end

        def self.#{sym}=(obj)
          @@#{sym} = obj
        end

        def #{sym}=(obj)
          @@#{sym} = obj
        end
      EOS
    end
  end

  def cattr_accessor(*syms)
    cattr_reader(*syms)
    cattr_writer(*syms)
  end
end if Class.instance_methods(false).grep(/^cattr_(?:reader|writer|accessor)$/).empty?