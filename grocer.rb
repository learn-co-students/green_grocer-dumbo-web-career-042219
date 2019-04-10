def consolidate_cart(cart)
  consolCart={}
  cart.each do |product|
    product.each do |productName, details|
      if consolCart[productName] == nil 
        consolCart[productName]= details
        consolCart[productName][:count]=1 
      else 
      consolCart[productName][:count]+= 1 
    end 
  end
end
consolCart
end 

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.key?(coupon[:item])
      couponCount = 0
      until coupon[:num] > cart[coupon[:item]][:count]
        cart[coupon[:item]][:count] -= coupon[:num]
        cart["#{coupon[:item]} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: couponCount += 1}
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product, details|
      if details[:clearance] == true 
        details[:price]= (details[:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolCart=consolidate_cart(cart)
  coupCart=apply_coupons(consolCart, coupons)
  finalCart=apply_clearance(coupCart)
  cartTotal=0 
  
  finalCart.each do |product, detail|
    cartTotal += detail[:price]* detail[:count]
  end
  
  if cartTotal > 100
    cartTotal= (cartTotal * 0.9)
  end
  cartTotal
end
