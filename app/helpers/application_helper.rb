module ApplicationHelper
  include Twitter::Autolink
  def cache_write(key, value, expires_in=nil)
    if !key.blank? and !value.blank?
      if Rails.cache.write(key, value, expires_in)
        defined?(logger) ? logger.debug("[CACHE WRITE] #{key}") : puts("[CACHE WRITE] #{key}")
      else
        defined?(logger) ? logger.debug("[CACHE WRITE ERROR] Cannot write cache #{key}") : puts("[CACHE WRITE ERROR] Cannot write cache #{key}")
      end
    else
      defined?(logger) ? logger.debug("[CACHE WRITE ERROR] key or value not present") : puts("[CACHE WRITE ERROR] key or value not present")
    end
    return value
  end

  def cache_read(key=nil)
    if !key.blank?
      if(value = Rails.cache.read(key))
        defined?(logger) ? logger.debug("[CACHE READ] #{key}") : puts("[CACHE READ] #{key}")
      else
        defined?(logger) ? logger.debug("[CACHE READ EMPTY] #{key}") : puts("[CACHE READ EMPTY] #{key}")
      end
    else
      defined?(logger) ? logger.debug("[CACHE READ ERROR] value not present") : puts("[CACHE READ ERROR] value not present")
      value = nil
    end
    return value
  end
end
