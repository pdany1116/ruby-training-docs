class Validator
  class << self
    def gem_name_valid?(gem_name)
      return false if gem_name.nil? or gem_name.empty?

      true
    end

    def keyword_valid?(keyword)
      return false if keyword.nil? or keyword.empty?

      true
    end
  end
end