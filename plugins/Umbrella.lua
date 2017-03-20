do

function run(msg)
	local uptime = io.popen('uptime'):read('*all')
	local rates = uptime:split("up")
	local rates1 = uptime:split(",")
	local rates1 = rates1[2]
	local rates = rates[2]
	local rates = rates:split(",  load")
	local rates = rates[1]
	local data = load_data(_config.moderation.data)
	local adminslist = ''
	for k,v in pairs(data['admins']) do
		adminslist = adminslist .. '> @'.. v ..'\n'
	end
	local settings = data[tostring("37523836")]['settings']
	local group_link = data[tostring("37523836")]['settings']['set_link']
	send_document("chat#id"..msg.to.id,"./file/spam.webp", ok_cb, false)
	return 'مشخصات فنی سرور :\n'
		..'مدت آنلاین: '..rates..' روز'..rates1..' ساعت'..'\n'
		..'Macintosh A9 Procesor\n'
		..'CPU : 16 Core\n'
		..'RAM : 32 GB\n'
		..'HDD : 2 x 4 TB\n'
		..'IPN : 7 MB/S\n'
		..'Port : 2 MB/s\n______________________________\n\n'
		..'نرخ گروه با ربات ضد اسپم آمبرلا :\n'
		..'یک ماه گروه وی آی پی = 10هزار تومان\n'
		..'دو ماه گروه وی آی پی = 15هزار تومان\n'
		..'سه ماه گروه وی آی پی = 20هزار تومان\n______________________________\n\n'
		..'توسئه دهندگان :\n'
		..'سازنده و صاحب امتیاز: @shayansoft\n'
		..'لیست مدیران :\n'..adminslist..'______________________________\n\n'
		..'پلهای ارتباطی :\n'
		..'وبسایت : www.Umbrella.shayan-soft.ir\n'
		..'کانال : https://telegram.me/umbrellateam\n'
		..'لینک ساپورت :\n'..group_link
end

return {
	description = "Umbrella Bot!", 
	usagehtm = '<tr><td align="center">Umbrella</td><td align="right">ارائه ی مشخصات سرور، مدت زمان آنلاین بودن سرور، تعرفه ی قیمتها، لینک ساپورت، لیست ادمینها و لینکهای مرتبط</td></tr>',
	usage = "umbrella : درباره آمبرلا",
	patterns = {
		"^[Uu]mbrella$"
	}, 
	run = run 
}
end