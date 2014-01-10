=begin
Code taken mostly from ActiveRecord::Cache
Copyright (c) 2005-2011 David Heinemeier Hansson

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=end
require 'digest/md5'
module SimpleCache
  #TODO: add a super-class and implement FileSystemCache
  class MemoryCache

    attr_reader :cache_size

    def initialize(options = {})
      @cache = {}
      @cache_size = 0
      @key_access = {}
      @max_size = options[:max_size] || 32 * 1024 #32 megabytes
      @timeout  = options[:timeout]  || 60*30 #30 minutes
    end

    def encode(key)
      Digest::MD5.hexdigest key
    end

    def delete(key)
      entry = @cache.delete key
      @key_access.delete key
      @cache_size -= entry.size
    end

    def [](key)
      key = encode(key)
      entry = @cache[key]
      if entry
        @key_access[key] = Time.now.to_f
      else
        @key_access.delete key
      end
      entry
    end

    def []=(key, value)
      key = encode(key)
      old_entry = @cache[key]
      @cache_size -= old_entry.size if old_entry
      @key_access[key] = Time.now.to_f
      @cache[key] = value
      @cache_size += value.to_s.size
      prune if @cache_size > @max_size
    end

    def has_key?(key)
      !!@cache[encode(key)]
    end

    def prune
      # first, the obvious cleanup
      @cache.keys.each do |key|
        delete(key) if stale? key
      end

      # now, try to leave it a 3/4 of it's capacity
      target_size = 0.75 * @max_size

      # delete the older entries
      sorted_keys = @key_access.keys.sort{|a,b| @key_access[a].to_f <=> @key_access[b].to_f}
      sorted_keys.each do |key|
        return if @cache_size <= target_size
        delete key
      end
    end

    def stale?(key)
      (Time.now.to_f - @key_access[key]) > @timeout.to_f
    end

    def clear
      @cache = {}
      @cache_size = 0
      @key_access = {}
    end

  end
end
