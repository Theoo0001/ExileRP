NoWhitelistAdaptive = [[
    {
        "type": "AdaptiveCard",
        "body": [
            {
                "type": "TextBlock",
                "text": "Niestety nie jesteś na Whiteliście",
                "maxLines": 1,
                "spacing": "None",
                "wrap": true,
                "horizontalAlignment": "Center",
                "size": "Large",
                "color": "Accent",
                "weight": "Bolder"
            },
            {
                "type": "ActionSet",
                "actions": [
                    {
                        "type": "Action.OpenUrl",
                        "title": "Odwiedź naszą stronę!",
                        "style": "positive",
                        "url": ""
                    },
                    {
                        "type": "Action.OpenUrl",
                        "title": "Dołącz do Discorda!",
                        "style": "positive",
                        "url": "https://discord.gg/exilerp"
                    }
                ]
            }
        ],
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "version": "1.0",
        "backgroundImage": {
            "url": "",
            "verticalAlignment": "Center",
            "horizontalAlignment": "Center"
        },
        "verticalContentAlignment": "Center"
    }
]]

cardRegister = {
	["type"] = "AdaptiveCard",
	["body"] = {
		{
			["type"] = "TextBlock",
			["text"] = "> Stworz postac",
			["weight"] = "bolder",
			["size"] = "large",
			["horizontalAlignment"] = "center"
		},
		{
			["type"] = "ColumnSet",
			["columns"] = {
				{
					["type"] = "Column",
					["items"] = {
						{
							["type"] = "Input.Text",
							["placeholder"] = "Imie postaci (15 znakow)",
							["id"] = "firstname"
						},
						{
							["type"] = "Input.Text",
							["placeholder"] = "Nazwisko postaci (15 znakow)",
							["id"] = "lastname"
						},
						{
							["type"] = "Input.Text",
							["placeholder"] = "Wzrost (np. 190)",
							["id"] = "height"
						},
						{
							["type"] = "Input.Date",
							["id"] = "dateofbirth",
							["value"] = "dd/mm/rrrr"
						},
						{
							["type"] = "Input.ChoiceSet",
							["id"] = "sex",
							["style"] = "expanded",
							["isMultiSelect"] = "false",
							["value"] = "m",
							["choices"] = {
									{
											["title"] = "Mezczyzna",
											["value"] = "m"
									},
									{
											["title"] = "Kobieta",
											["value"] = "f"
									}
							}
						}
					},
					["width"] = "stretch"
				}
			}
		}
	},
	["actions"] = {
			{
					["title"] = "Stworz postać",
					["type"] = "Action.Submit",
					["data"] = {
							["x"] = "setupChar"
					}
			}
	},
	["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
	["version"] = "1.0"
}