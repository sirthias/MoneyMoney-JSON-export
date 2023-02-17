--
-- MoneyMoney JSON Export Extension
-- http://moneymoney-app.com/api/export
--
-- Export transactions as JSON file.
--

local encoding = "UTF-8"

Exporter{version       = 1.02,
         format        = "JSON file",
         fileExtension = "json",
         description   = "Export transactions as JSON file"}


local function jsonField (str)
  if str == nil then
    return ""
  else
    return string.gsub(str, '"', '\\"')
  end
end

local function isoDate(date)
  return MM.localizeDate("yyyy-MM-dd", date)
end

local function amount(value)
  return MM.localizeAmount("0.00;-0.00", value)
end  

local comma

function WriteHeader (account, startDate, endDate, transactionCount)
  assert(io.write(MM.toEncoding(encoding, '{\n' ..
                                          '  "startDate": "' .. jsonField(isoDate(startDate)) .. '",\n' ..
                                          '  "endDate": "' .. jsonField(isoDate(endDate)) .. '",\n' ..
                                          '  "transactionCount": ' .. transactionCount .. ',\n' ..
                                          '  "name": "' .. jsonField(account.name) .. '",\n' ..
                                          '  "owner": "' .. jsonField(account.owner) .. '",\n' ..
                                          '  "accountNumber": "' .. jsonField(account.accountNumber) .. '",\n' ..
                                          '  "subAccount": "' .. jsonField(account.subAccount) .. '",\n' ..
                                          '  "bankCode": "' .. jsonField(account.bankCode) .. '",\n' ..
                                          '  "currency": "' .. jsonField(account.currency) .. '",\n' ..
                                          '  "iban": "' .. jsonField(account.iban) .. '",\n' ..
                                          '  "bic": "' .. jsonField(account.bic) .. '",\n' ..
                                          '  "type": "' .. jsonField(account.type) .. '",\n' ..
                                          '  "comment": "' .. jsonField(account.comment) .. '",\n' ..
                                          '  "balance": "' .. jsonField(amount(account.balance)) .. '",\n' ..
                                          '  "balanceDate": "' .. jsonField(isoDate(account.balanceDate)) .. '",\n' ..
                                          '  "attributes": [')))

  comma = ""
  for _,attr in ipairs(account.attributes) do
    assert(io.write(MM.toEncoding(encoding, comma .. '"' .. jsonField(attr) .. '"')))
    comma = ", "
  end
  assert(io.write(MM.toEncoding(encoding, '],\n  "transactions": [\n')))
  comma = ""
end

function WriteTransactions (account, transactions)
  for _,transaction in ipairs(transactions) do

    assert(io.write(MM.toEncoding(encoding, comma .. '  {\n' ..
                                            '    "id": ' .. jsonField(transaction.id) .. ',\n' ..
                                            '    "bookingDate": "' .. jsonField(isoDate(transaction.bookingDate)) .. '",\n' ..
                                            '    "valueDate": "' .. jsonField(isoDate(transaction.valueDate)) .. '",\n' ..
                                            '    "name": "' .. jsonField(transaction.name) .. '",\n' ..
                                            '    "accountNumber": "' .. jsonField(transaction.accountNumber) .. '",\n' ..
                                            '    "bankCode": "' .. jsonField(transaction.bankCode) .. '",\n' ..
                                            '    "purpose": "' .. jsonField(transaction.purpose) .. '",\n' ..
                                            '    "transactionCode": ' .. transaction.transactionCode .. ',\n' ..
                                            '    "textKeyExtension": ' .. transaction.textKeyExtension .. ',\n' ..
                                            '    "purposeCode": "' .. jsonField(transaction.purposeCode) .. '",\n' ..
                                            '    "comment": "' .. jsonField(transaction.comment) .. '",\n' ..
                                            '    "bookingKey": "' .. jsonField(transaction.bookingKey) .. '",\n' ..
                                            '    "bookingText": "' .. jsonField(transaction.bookingText) .. '",\n' ..
                                            '    "primanotaNumber": "' .. jsonField(transaction.primanotaNumber) .. '",\n' ..
                                            '    "batchReference": "' .. jsonField(transaction.batchReference) .. '",\n' ..
                                            '    "returnReason": "' .. jsonField(transaction.returnReason) .. '",\n' ..
                                            '    "endToEndReference": "' .. jsonField(transaction.endToEndReference) .. '",\n' ..
                                            '    "mandateReference": "' .. jsonField(transaction.mandateReference) .. '",\n' ..
                                            '    "creditorId": "' .. jsonField(transaction.creditorId) .. '",\n' ..
                                            '    "category": "' .. jsonField(string.gsub(transaction.category, [[\]], " - ")) .. '",\n' ..
                                            '    "booked": ' .. tostring(transaction.booked) .. ',\n' ..
                                            '    "checkmark": ' .. tostring(transaction.checkmark) .. ',\n' ..
                                            '    "amount": "' .. jsonField(amount(transaction.amount)) .. '",\n' ..
                                            '    "currency": "' .. jsonField(transaction.currency) .. '"\n  }')))

    comma = ","
  end
end


function WriteTail (account)
  assert(io.write("\n  ]\n}\n"))
end
