

def consolidate_cart(cart)
  answer = Hash.new
  cart.each do |item|
    if answer[item.keys[0]] == nil
      answer.merge!(item)
      answer[item.keys[0]].merge!({:count => 1})
    else
      answer[item.keys[0]][:count] += 1
    end
  end
  answer
end

def apply_coupons(cart, coupons)
  coupons.map do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      if cart["#{coupon[:item]} W/COUPON"]
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      else
        cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost],
        :clearance => cart[coupon[:item]][:clearance], :count => 1}
      end
      cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(1)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end
