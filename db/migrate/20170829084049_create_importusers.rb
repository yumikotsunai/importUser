class CreateImportusers < ActiveRecord::Migration
  def change
    create_table :importusers do |t|

      t.timestamps null: false
    end
  end
end
