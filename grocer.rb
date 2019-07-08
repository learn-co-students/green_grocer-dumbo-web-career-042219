require 'pry'
def consolidate_cart(cart)
  hash = {}
  
  cart.each do |item|
    item.each do |key, val|
      hash[key] = val
      hash[key][:count] = cart.count(item)
    end
  end
  
  hash
end

def apply_coupons(cart, coupons)
  hash = {}
  return cart if coupons.empty?

  cart.each do |item, values|
    hash[item] = values
    coupons_applied = []
    coupons.each do |ele|
      if item == ele[:item] && hash[item][:count] >= ele[:num]
        coupons_applied << ele
        hash[item + " W/COUPON"] = {:price => ele[:cost], :clearance => values[:clearance], :count => coupons_applied.count}
        hash[item][:count] -= ele[:num] if item == ele[:item]
      end
    end
  end
  
  hash
end

def apply_clearance(cart)
  cart.each do |key, val|
    if val[:clearance]
      val[:price] *= 0.80
      val[:price] = val[:price].truncate(1)
    end
  end
  
  cart
end

def checkout(cart, coupons)
  sum = 0
  
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(couponed_cart)
  
  clearance_cart.each do |key, val|
    sum += (val[:price] * val[:count])
  end
  
  if sum > 100
    sum *= 0.9
  end
  
  sum
end
