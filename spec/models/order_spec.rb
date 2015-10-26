require 'rails_helper'

RSpec.describe Order do
  it 'calculates the total price of the order' do
    item1 = FactoryGirl.create(:item)
    item2 = FactoryGirl.create(:item, price: 20)

    order = FactoryGirl.create(:order)
    order.items << item1
    order.items << item2

    order.calculate_total
    expect(order.total).to eq(30)

  end

  it 'raises exception if order no items in it' do
    expect( -> { FactoryGirl.create(:order) } ).to raise_exception
  end

end