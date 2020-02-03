# inspiration https://github.com/bbugyi200/dotfiles

# userscripts located at ~/.local/share/qutebrowser/usercripts

# initiate editor with custom vimrc
# c.editor.command = ['urxvt', '-name', 'qute-editor', '-e','vim', '-S', '~/.config/qutebrowser/editor.vimrc', '{}']
# c.editor.command = ['urxvt', '-name', 'qute-editor', '-e','vim', '-S', '{}']
# c.editor.command = ["emacsclient", "-c", " {file}"]
# c.editor.command = ['urxvt', '-name', 'qute-editor', '-e','vim', '-S', '{file}']
c.editor.command = ['urxvt', '-e','vim', '{}']


# custom commands

# userscripts
config.bind('zf', 'spawn --userscript open-url-in-firefox')
config.bind('zg', 'spawn --userscript ddg-to-google')
config.bind('zy', 'spawn --userscript google-results-year')
config.bind('zv', 'spawn --userscript readability')
config.bind('ze', 'spawn --userscript searchbar-command')
config.bind('zs', 'spawn --userscript redirect-pbtynpj')
config.bind('zm', 'spawn --userscript archive-url')
config.bind('zum', 'spawn --userscript undo-archive-url')
config.bind('zx', 'spawn --userscript sx-close-consent-bar')

# set marks
config.unbind('m')
config.bind('mm', 'set-mark m')
config.bind('mn', 'set-mark n')
config.bind('ma', 'set-mark a')

# other
config.bind('zo', 'download-open')
config.bind('e', 'open-editor')
config.bind('cs', 'config-source')
config.bind('tg', 'tab-give')
config.bind('<Ctrl-n>', 'config-cycle statusbar.hide')
config.bind('U', 'tab-focus last')


# search engines
# c.url.searchengines = {"DEFAULT":'https://google.com/search?hl=en&q={}'}
c.url.searchengines = {
   "DEFAULT":'https://start.duckduckgo.com/?q={}',
   "np": 'https://nixos.org/nixos/packages.html?channel=nixos-unstable&query={}',
   "no": 'https://nixos.org/nixos/options.html#{}',
   "hg": 'https://hoogle.haskell.org/?hoogle={}',
   "gl": 'http://gen.lib.rus.ec/search.php?req={}',
   "yc": 'https://www.google.com/search?hl=en&q=site%3Anews.ycombinator.com%20{}', # hacker news
}

## general settings

# page displayed when opening new tab
c.url.default_page = "about:blank"
c.url.start_pages = "about:blank"

# dowlnoad directory
c.downloads.location.directory="~/downloads"

# hint characters
c.hints.chars = "arstneio"

# height of completion bar
c.completion.height = "30%"

c.tabs.show = "multiple"

# delete cookies on exit
c.content.cookies.store = False

# toggle dark theme using solarized-everything
## see https://www.reddit.com/r/qutebrowser/comments/665wdb/is_there_a_dark_mode/
# config.bind('<Ctrl-r>', 'config-cycle content.user_stylesheets ~/solarized.css ""')
