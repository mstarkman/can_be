module ModelMacros
  def new_address(can_be_type = 'home')
    Address.new(can_be_type: can_be_type.to_s)
  end

  def create_address(can_be_type = 'home')
    Address.create(can_be_type: can_be_type.to_s)
  end
end
