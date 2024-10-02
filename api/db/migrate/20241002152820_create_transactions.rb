class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.date :date
      t.string :category

      t.timestamps
    end
  end
end
