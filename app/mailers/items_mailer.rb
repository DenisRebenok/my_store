class ItemsMailer < ApplicationMailer
  default from: "info@mystore.localhost",
          template_path: 'mailers/items'

  def item_destroyed(item)
    @item = item
    mail to: 'denis.rebenok.pro@gmail.com',
         subject: "Item destroyed"
  end
end
