require "digest/md5"

module Helper
  def r_name
    Digest::MD5.hexdigest(Time.now.to_f.to_s)
  end
end
  
