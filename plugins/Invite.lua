do
local function callbackres(extra, success, result)
	local user = 'user#id'..result.id
	local chat = 'chat#id'..extra.chatid
	chat_add_user(chat, user, ok_cb, false)
end

local function run(msg, matches)
	if matches[1] == "&join" and is_admin(msg) then
		chat_add_user('chat#id'..matches[2], "user#id"..msg.from.id, ok_cb, false)
	else
		if msg.to.type == 'chat' and is_momod(msg) then
			if string.match(matches[2], '^%d+$') then
				local chat = 'chat#id'..msg.to.id
				chat_add_user(chat, "user#id"..matches[2], ok_cb, false)
			else
				local username = matches[2]
				local username = username:gsub("@","")
				local cbres_extra = {chatid = msg.to.id}
				res_user(username,  callbackres, cbres_extra)
			end
		end
	end
end

return {
	description = "Invite Members by Username or ID", 
	usagehtm = '<tr><td align="center">inv یوزرنیم یا آیدی</td><td align="right">افزودن افراد به گروه با یوزرنیم یا آی دی</td></tr>',
	usage = {
		moderator = {
			"inv (@user|id) : افزودن افراد",
			},
		},
	patterns = {
		"^(&join) (%d+)$",
		"^[Ii](nv) (.*)$",
		"^[Ii](nvite) (.*)$",
	}, 
	run = run,
	moderation = true 
}

end