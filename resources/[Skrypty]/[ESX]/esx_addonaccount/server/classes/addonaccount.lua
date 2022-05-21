function CreateAddonAccount(name, owner, money, account_money)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money
	self.account_money = account_money
	
	self.addMoney = function(m)
		self.money = self.money + m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.addAccountMoney = function(m)
		self.account_money = self.account_money + m

		self.save()

		TriggerClientEvent('esx_addonaccount:setAccountMoney', -1, self.name, self.account_money)
	end

	self.removeMoney = function(m)
		self.money = self.money - m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.removeAccountMoney = function(m)
		self.account_money = self.account_money - m

		self.save()

		TriggerClientEvent('esx_addonaccount:setAccountMoney', -1, self.name, self.account_money)
	end

	self.setMoney = function(m)
		self.money = m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end
	
	self.setAccountMoney = function(m)
		self.account_money = m

		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.account_money)
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money, account_money = @account_money WHERE account_name = @account_name',
			{
				['@account_name'] = self.name,
				['@money']        = self.money,
				['@account_money'] = self.account_money
			})
		else
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner',
			{
				['@account_name'] = self.name,
				['@money']        = self.money,
				['@owner']        = self.owner
			})
		end
	end

	return self
end