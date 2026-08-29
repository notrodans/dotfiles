return {
	enabled = false,
	"neo451/feed.nvim",
	cmd = "Feed",
	opts = {
		feeds = {
			{
				"https://www.yegor256.com/rss.xml",
				name = "Yegor Bugayenko Blog",
			},
			news = {
				tech = {
					{ "https://neovim.io/news.xml", name = "Neovim News" },
				},
			},
		},
	},
}
