class CreateSchoolClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :school_classes do |t|
      t.references :school, null: false, foreign_key: true
      t.integer :number
      t.string :letter

      t.timestamps
    end
  end
end
