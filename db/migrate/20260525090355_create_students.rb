class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :surname
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
