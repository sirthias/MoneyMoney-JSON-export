--
-- MoneyMoney JSON Export Extension
-- http://moneymoney-app.com/api/export
--
-- Export transactions as JSON file.
--

local encoding = "UTF-8"

Exporter{version       = 1.01,
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

local comma

function WriteHeader (account, startDate, endDate, transactionCount)
  assert(io.write("[\n"))
  comma = ""
end

function WriteTransactions (account, transactions)
  for _,transaction in ipairs(transactions) do

    assert(io.write(MM.toEncoding(encoding, comma .. '{\n' ..
                                            '  "id": "' .. jsonField(transaction.id) .. '",\n' ..
                                            '  "bookingDate": "' .. jsonField(MM.localizeDate(transaction.bookingDate)) .. '",\n' ..
                                            '  "valueDate": "' .. jsonField(MM.localizeDate(transaction.valueDate)) .. '",\n' ..
                                            '  "name": "' .. jsonField(transaction.name) .. '",\n' ..
                                            '  "accountNumber": "' .. jsonField(transaction.accountNumber) .. '",\n' ..
                                            '  "bankCode": "' .. jsonField(transaction.bankCode) .. '",\n' ..
                                            '  "purpose": "' .. jsonField(transaction.purpose) .. '",\n' ..
                                            '  "transactionCode": "' .. jsonField(transaction.transactionCode) .. '",\n' ..
                                            '  "textKeyExtension": "' .. jsonField(transaction.textKeyExtension) .. '",\n' ..
                                            '  "purposeCode": "' .. jsonField(transaction.purposeCode) .. '",\n' ..
                                            '  "comment": "' .. jsonField(transaction.comment) .. '",\n' ..
                                            '  "bookingKey": "' .. jsonField(transaction.bookingKey) .. '",\n' ..
                                            '  "bookingText": "' .. jsonField(transaction.bookingText) .. '",\n' ..
                                            '  "primanotaNumber": "' .. jsonField(transaction.primanotaNumber) .. '",\n' ..
                                            '  "batchReference": "' .. jsonField(transaction.batchReference) .. '",\n' ..
                                            '  "returnReason": "' .. jsonField(transaction.returnReason) .. '",\n' ..
                                            '  "endToEndReference": "' .. jsonField(transaction.endToEndReference) .. '",\n' ..
                                            '  "mandateReference": "' .. jsonField(transaction.mandateReference) .. '",\n' ..
                                            '  "creditorId": "' .. jsonField(transaction.creditorId) .. '",\n' ..
                                            '  "category": "' .. jsonField(string.gsub(transaction.category, [[\]], " - ")) .. '",\n' ..
                                            '  "amount": "' .. jsonField(MM.localizeAmount("0.00;-0.00", transaction.amount)) .. '",\n' ..
                                            '  "currency": "' .. jsonField(transaction.currency) .. '"\n}')))

    comma = ","
  end
end


function WriteTail (account)
  assert(io.write("\n]"))
end
