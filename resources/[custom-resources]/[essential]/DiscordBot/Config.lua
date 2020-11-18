DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/715238164733624380/80HxKVOr799K4pj7Vfee-3_1F8VJsBTCx5FjAaakFG5GEwLZQi0TLneC35Ix4LLDpjdH'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/715238231809196073/b0Y_2NX8e8d7CESQK25fNxpRUhW0SrHou_jWlfXx_roloQJq9p7al-h9fBp_rMvyLD5q'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/715238309634506752/rkjGiuRgeIIzIOeRSJbj60SuyF4RHQcddn1lUYDxNvaA4DKGEm5tUNlbSh1CGPLJB2XD'
DiscordWebhookScriptError = 'https://discordapp.com/api/webhooks/715238392849498220/SfsrMTINhknajA8Z-YWTjofXJgfyA3et13IHOMSLCszIoZgVEMZp8HewJ0sqsUtdyrG9'
DiscordWebhookClocking = 'https://discordapp.com/api/webhooks/716987891078791188/bTuR-NIspcav1gtzAEKEcH-K-HjaetigCBsdRTgIkr5nKSeIJQFS-Bd_aTlT1I03fkfz'
DiscordInvLog = 'https://discordapp.com/api/webhooks/717173610007101471/KbO22MufW4dQyaczEwqcJdyJBWNR3zlj0aFN_evgnMRhIdwVbf7fei6rUhilv-KW-QLE'
DiscordMoneyLog = 'https://discordapp.com/api/webhooks/760212199938457710/Uu4PVfeiCjVL7stPcCnPGkobWXu8l3t33gERRckpSSULPiENXcpb7OAKRWwVThdrJTXX'
DiscordMDTLog = 'https://discordapp.com/api/webhooks/748657114808844328/euhsdNYPTUOLpvVLuQS65WgwIDn5SZnVBiOMdBzByuGwDbWSrZmNu8YNMHz9yFoow8Js'
AFKLog = 'https://discordapp.com/api/webhooks/721885606346620999/UJycIwiqBg0WXOYvh_buTXeFaUPn_eLpqc-mxChaMCKAF5VH8oWe8d0YjqtSapTtw4Km'
exLog = 'https://discordapp.com/api/webhooks/723989320465121822/nIlS04PGWIyySjwkuketc9sldAI1Si-urazjBpAhnyhpL08-pdrDSYMNfD0lgbBv6MnK'
cheatLog = 'https://discordapp.com/api/webhooks/741006179236577331/68AGkGNxX_ECdT8xq-Oc8C5RuW092WcslggkYtg1QecCCuAFucMM9nCq88UzquTNsbom'
houseLog = 'https://discordapp.com/api/webhooks/730461542444695574/lAQ8Uxgb3Fdn9cdxbWFN5ANrbFDTWCWo3y4ONz-Tzh710d4TZGCtxF62PM4OYQPi6ASl'
societyLog = 'https://discordapp.com/api/webhooks/736244458848256100/J4zRjRHDM1FPZZCUM3upLCbNPEWcp2xb_xkHkd4jAh0d-HUZtvFhkWVyq2KNizYxrLod'

SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

SystemName = 'SYSTEM'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/AnotherCommand', 'WEBHOOK_LINK_HERE'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

