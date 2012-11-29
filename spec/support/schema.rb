ActiveRecord::Schema.define do
  self.verbose = false

  create_table :addresses, :force => true do |t|
    t.string :can_be_type
    t.timestamps
  end

  create_table :people, :force => true do |t|
    t.string :gender
    t.timestamps
  end
end
