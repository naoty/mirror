module Mirror
  class Card
    def initialize(attrs = {})
      @text = attrs[:text]
      @speakableText = attrs[:speakableText] || attrs[:speakable_text]
      @notification = attrs[:notification]
      @menuItems = attrs[:menuItems] || attrs[:menu_items]
    end

    def to_item
      item = {}
      instance_variables.each do |name|
        value = instance_variable_get(name)
        next if value.nil?
        key = name.to_s[1..-1].to_sym
        item[key] = value
      end
      item
    end
  end
end
