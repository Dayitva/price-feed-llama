-- ADD to your World or WorldTemplate.lua using below
-- RealityEntitiesStatic = {
--     ['PID WHERE LLAMA LOADED'] = {
--           Position = { 6, 6 },
--           Type = 'Avatar',
--           Metadata = {
--             DisplayName = '0rbit Llama',
--             SkinNumber = 3,
--             Interaction = {
--               Type = 'SchemaForm',
--               Id = 'GetRealData'
--             },
--           },
--         },
--   }

local json = require('json')

-- Configure this to the process ID of the world you want to send chat messages to
CHAT_TARGET = 'D-gNmZWSLE-pxxDTSNme5tGpS2NjANPqdLCrBjOAfPk'

_0RBIT = "BaMK1dfayo75s3q1ow6AO64UDpD9SEFbeE8xYrY2fyQ"
_0RBT_TOKEN_PROCESS = "BUhZLMwQ6yZHguLtJYA5lLUa9LQzLXMXRfaq9FVcPJc"

change = false

function Validate0rbtQuantity(quantity)
  return quantity == 1000000000000
end

function ValidateJsonResource(resource)
  return resource ~= nil and type(resource) == 'string'
end


Handlers.add('Schema', Handlers.utils.hasMatchingTag('Action', 'Schema'), 
function(msg)
	print('Schema')
	local sender = msg.From
  change = false
  print("in schema".. tostring(change))
	Send({
		Target = msg.From,
		Tags = {
			Type = 'Schema'
		},
		Data = json.encode({
			PriceFeedLlama = {
				Title = "What price feed would you like to fetch?",
				Description = "Please enter the ticker of the token you would like to see the price of.",
				Schema = {
					Tags = {
						type = "object",
						required = {
							"Action",
              "Quantity"
						},
						properties = {
							Action = {
								type = "string",
								const = "SendReq"
							},
              Quantity = {
                type = "string",
                const = "1000000000000"
              },
              ["X-Response"] = {
								type = "string",
								title = "Enter the ticker:",
								minLength = 1,
								maxLength = 10,
                default= "AR",
							}
						}
					}
				}
			}
		})
	})
end)

Handlers.add('SendReq', 
  Handlers.utils.hasMatchingTag('Action', 'SendReq'), 
    function(msg)
      print("SAYING Send")
      print("in send req".. tostring(change)) 
      local token = msg.Tags["X-Response"] 
      local url = string.format("https://api.coinbase.com/v2/prices/%s-USD/spot", token)
      -- if(string.sub(url, 1, #prefix) ~= prefix) then 
      --   change = true
      --   print("in if cond".. tostring(change))
      -- end
      print(msg.Tags.Quantity)
      Send({
              Target = _0RBT_TOKEN_PROCESS,
                Action = 'Transfer',
                Recipient = _0RBIT,
                Quantity = msg.Tags.Quantity,
                ["X-Url"] = url,
                ["X-Action"] = "Get-Real-Data"
            }) 
      print(msg.Tags["X-Response"])
    end
)

Handlers.add(
    "Receive-Data",
    Handlers.utils.hasMatchingTag("Action", "Receive-Response"),

    function(msg)
        print("in recieve".. tostring(change))
        local res = json.decode(msg.Data)
        print(res)
        -- USE constrained string to display some of the data raw, long strings are skipped and not displayed
        local price = string.format("%." .. (3) .. "f", res["data"]["amount"])
        local token = res["data"]["base"]
        print(price)
        print(Colors.green .. "You have received the data from the 0rbit process.")
        -- Write in Chat
        Send({
          Target = CHAT_TARGET,
          Tags = {
            Action = 'ChatMessage',
            ['Author-Name'] = '0rbit Llama',
          },
          Data = "Current price of " .. token .. " is $" .. price,
        })
        print("Current price of " .. token .. " is $" .. price)
      
    end
)