class Registration < ActiveRecord::Base
	belongs_to :order
	has_one :card
  accepts_nested_attributes_for :card

  validates :full_name, :company, :email, :telephone, :quantity, presence: true

  serialize :notification_params, Hash

  def paypal_url(return_path)
    values = {
        business: "merchant@gotealeaf.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: order.price * self.quantity,
        item_name: order.name,
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  def payment_method
    if card.nil? then "paypal"; else "card"; end
  end

end
