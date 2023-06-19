module ApplicationHelper

  def hash_converter(string)
    string.gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
  end
end
