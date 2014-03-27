class AddBidStatusToBid < ActiveRecord::Migration
  def change
    add_column :bids, :bid_status, :string, :default => 'open'
  end
end
