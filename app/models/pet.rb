class Pet < ActiveRecord::Base
  validates :name, presence: true
  validates :human, presence: true
  validates :age, presence: true
# this helps without having to change this each time you add a new attribute?

# any time you want to overwrite default beahvior of active record.

def as_json( options={} )
  options = options.merge only: [:id,:name, :age, :human]
  super(options)
end

end
