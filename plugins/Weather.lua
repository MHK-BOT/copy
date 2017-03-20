local function run(msg, matches)
	local res = http.request("https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20in%20%28select%20woeid%20from%20geo.places%281%29%20where%20text%3D%22"..URL.escape(matches[1]).."%22%29&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
	local jtab = JSON.decode(res)
	if jtab.query.count == 1 then
		data = jtab.query.results.channel.item.condition
		celsius = string.format("%.0f", (data.temp - 32) * 5/9)
		return "همینک آب و هوا در "..matches[1].."\n\n"
			.."دمای هوا به سلسیوس: "..celsius.."°C\n"
			.."دمای هوا به فارنهایت: "..data.temp.."°F\n"
			.."وضعیت آب و هوا: "..data.text
	else
		return "مکان وارد شده صحیح نیست"
	end
end

return {
	description = "Weather Status",
	usagehtm = '<tr><td align="center">weather شهر</td><td align="right">نمایش وضعیت آب و هوا همچنین دمای هوای تمامی شهر های جهان به واحد سلسیوس و فارنهایت. میتوانید نام شهر را پارسی یا لاتین وارد کنید</td></tr>',
	usage = {"weather (city) : وضعیت آب و هوا"},
	patterns = {"^[Ww]eather (.*)$"},
	run = run,
}