module UserAttributeProperties

  def visible_for(member)
    select do |element|
      next true if element.visible?
      next true if %w(owner manager).include? member.try(:rights)
      next true if member.user == element.user
      false
    end
  end

end
