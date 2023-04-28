class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, &:timestamps
  end
end
