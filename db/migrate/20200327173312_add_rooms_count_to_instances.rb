class AddRoomsCountToInstances < ActiveRecord::Migration[5.2]
  def change
    add_column :instances, :rooms_count, :integer
    Instance.find_each do |instance|
      Instance.reset_counters(instance.id, :rooms)
    end
  end
end
