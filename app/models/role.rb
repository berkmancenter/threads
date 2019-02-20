class Role < ActiveRecord::Base
  NAMES = %w(
    admin
    owner
    moderator
    registered
    anonymous
  )

  NAMES.each do |name|
    define_singleton_method(name) do
      where(name: name).first || create(name: name)
    end
  end

  has_and_belongs_to_many :users
end
