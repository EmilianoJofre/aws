class SetNotNullAveragePriceAndMovementType < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      execute 'ALTER TABLE "money_movements" ADD CONSTRAINT "money_movements_average_price_null" CHECK ("average_price" IS NOT NULL) NOT VALID'
      execute 'ALTER TABLE "money_movements" ADD CONSTRAINT "money_movements_movement_type_null" CHECK ("movement_type" IS NOT NULL) NOT VALID'
    end
  end
end
