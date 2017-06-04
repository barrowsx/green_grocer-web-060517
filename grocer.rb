require 'pry'
def consolidate_cart(cart)
  hash_to_return = {}
  cart.each do |item|
    item.each do |type, info|
      if hash_to_return[type].nil?
        hash_to_return[type] = info
        hash_to_return[type][:count] = 1
      else
        hash_to_return[type][:count] += 1
      end
    end
  end
  hash_to_return
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart[coupon[:item]]
      if cart[coupon[:item]][:count] >= coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
        if cart["#{coupon[:item]} W/COUPON"].nil?
          cart["#{coupon[:item]} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: 1}
        else
          cart["#{coupon[:item]} W/COUPON"][:count] += 1
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance]
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart_total = 0
  consolidated_cart = consolidate_cart(cart)
  new_cart = apply_coupons(consolidated_cart, coupons)
  working_cart = apply_clearance(new_cart)
  working_cart.each do |item, info|
    cart_total += info[:price] * info[:count]
  end
  if cart_total > 100
    cart_total = cart_total * 0.9
  end
  cart_total
end
