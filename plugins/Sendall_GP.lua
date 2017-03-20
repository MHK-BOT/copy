local function run(msg, matches)
	if is_sudo(msg) then
		local data = load_data(_config.moderation.data)
		i=1
		for k,v in pairs(data) do
			if k == "admins" then
				i=i-1
			else
				send_large_msg('chat#id'..k, matches[1])
				--message = message..k..'\n'
			end
			i=i+1
		end
		return send_large_msg('chat#id'..msg.to.id, 'پيام شما به '..i..' گروه ارسال شد')
	else
		return send_large_msg('chat#id'..msg.to.id, 'فقط سودو قادر به ارسال پیام به همه ي گروه ها است')
	end
end
	
return {
	description = 'Send to All Groups',
	usagehtm = '<tr><td align="center">/sendall پیام</td><td align="right">ارسال پیام به همه ی گروه ها مانند اخبار و پیام تبلیغاتی. دسترسی فقط برای سودو میباشد</td></tr>',
    usage = {
		sudo = {
			'/sendall (pm) : ارسال به همه گروه ها',
		},
    },
    patterns = {
		"^/sendall (.*)$",
	},
	run = run
}