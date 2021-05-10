library(tidyverse)
library(RobinHood)

user = 'ENTER_EMAIL_HERE'
pass = 'ENTER_PASSWORD_HERE'
symbol = 'DOGE'

## Connect to your Robinhood account; mfa_code is optional
api <- RobinHood(username = user, password = pass, mfa_code='')

## Get crypto price
quote <- get_quote_crypto(api, symbol)

## If price drops to a certain number, sell a specified quantity
sell.if.drops.to <- 0.425
quantity <- 1

# Save output to log.txt file
sink("log.txt")

while (TRUE){
  
  quote <- get_quote_crypto(api, symbol)
  
  mark.price <- quote$mark_price
  
  print(paste('Current Price:',mark.price))
  
  if(mark.price <= sell.if.drops.to){
    
    print(paste('Current Price below limit. Selling', quantity))
    
    place_order_crypto(api, 
                       symbol = symbol, 
                       type='limit', 
                       time_in_force='gtc', 
                       price = sell.if.drops.to, 
                       quantity = quantity, 
                       side = 'sell')
    
    # After executed, kill this process (i.e. do not continue to sell every 15 minutes even if price remains below limit.)
    stop('Executed sell order.')
    
  }else{

  print('Current Price Not Below Limit; Sleeping for 15 minutes, Then Will Check Again.')
  
  Sys.sleep(60*60*15) # Sleep for 15 minutes, then checks price again.
  
  }
  
}


