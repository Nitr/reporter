class CreateReporterReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reporter_reports do |t|
      t.string :type, null: false
      t.string :status, null: false, default: 'pending'
      t.jsonb :form, null: false, default: {}
      t.timestamp :processed_at
      t.timestamps
    end
  end
end
