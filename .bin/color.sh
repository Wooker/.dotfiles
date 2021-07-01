#!/bin/fish

# qutebrowser	~/.config/qutebrowser/config.py
# bspwm			~/.Xresources
# polybar		~/.config/polybar/config

set -L BACKUP ~/.backup_colorscheme
set -l COLORSCHEME_CONF ~/.config/colorscheme.conf

set QB ~/.config/qutebrowser/config.py
set STARTPAGE ~/.config/qutebrowser/startpage/index.html
set POLYBAR ~/.config/polybar/config
set ALACRITTY ~/.config/alacritty/alacritty.yml
set FISH ~/.config/fish/config.fish
set BSPWM ~/.config/bspwm/bspwmrc
set NVIM ~/.config/nvim/init.vim
set ROFI ~/.config/rofi/config.rasi
set RANGER ~/.config/ranger/rc.conf
set SPICETIFY ~/.config/spicetify/config.ini
set ZATHURA ~/.config/zathura/zathurarc

set COLORSCHEME (cat $COLORSCHEME_CONF)
set PREV

set LIGHT_BACK ~/Pictures/potential_wallpapers/light.jpg
set DARK_BACK ~/Pictures/potential_wallpapers/dark.jpg

if test $COLORSCHEME = "gruvbox"
	set COLORSCHEME ayu
	set PREV gruvbox
else
	set COLORSCHEME gruvbox
	set PREV ayu
end

echo "Changing theme from" $PREV "to" $COLORSCHEME


echo $COLORSCHEME > $COLORSCHEME_CONF

function change_qutebrowser # {{{
	cp $QB $BACKUP
	sed "103,408 s/$PREV/$COLORSCHEME/g" -i $QB
	if test $COLORSCHEME = "ayu"
		sed "9 s/28/fa/g
			10 s/a89984/e6e1cf/g
			11 s/ebdbb2/5c6773/g
			188 s/white/black/g
			" -i $STARTPAGE
		sed "7 s/^/#/" -i $QB
	else
		sed "9 s/fa/28/g
			10 s/e6e1cf/a89984/g
			11 s/5c6773/ebdbb2/g
			188 s/black/white/g
			" -i $STARTPAGE
		sed "7 s/^#//" -i $QB
	end
	echo "Qutebrowser configured."
end # }}}

function change_polybar # {{{
	cp $POLYBAR $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "117,154 s/^;f/f/
			117,154 s/^;b/b/
			117,154 s/^;c/c/
			161 s/^b/;b/
			162 s/^f/;f/
			165,180 s/^c/;c/
			187,599 s/gruvbox/ayu/
			76,77 s/gruvbox/ayu/
			" -i $POLYBAR
	else
		sed "117,154 s/^f/;f/
			117,154 s/^b/;b/
			117,154 s/^c/;c/
			161 s/^;b/b/
			162 s/^;f/f/
			165,180 s/^;c/c/
			187,599 s/ayu/gruvbox/
			76,77 s/ayu/gruvbox/
			" -i $POLYBAR
	end

	echo "Polybar configured."
end # }}}

function change_alacritty # {{{
	cp $ALACRITTY $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "335 s/dark/light/" -i $ALACRITTY
	else
		sed "335 s/light/dark/" -i $ALACRITTY
	end

	echo "Alacritty configured."
end # }}}

function change_fish # {{{
	cp $FISH $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "14 s/^/#/
		     13 s/^#//
			 " -i $FISH
	else
		sed "13 s/^/#/
		     14 s/^#//
			 " -i $FISH
	end

	echo "Fish configured."
end # }}}

function change_term # {{{
	change_fish
	change_alacritty
	echo "Terminal configured."
end # }}}

function change_background # {{{
	cp $BSPWM $BACKUP
	if test $COLORSCHEME = "ayu"
		hsetroot -solid white -full $LIGHT_BACK > /dev/null
		sed "6 s/^#//
		     7 s/^/#/
			 " -i $BSPWM
	else
		hsetroot -fill $DARK_BACK > /dev/null
		sed "6 s/^/#/
		     7 s/^#//
			 " -i $BSPWM
	end

	echo "Background configured."
end # }}}

function change_nvim # {{{
	if test $COLORSCHEME = "ayu"
		sed "s/colorscheme gruvbox/colorscheme ayu/
		     s/background=dark/background=light/
			 " -i $NVIM
	else
		sed "s/colorscheme ayu/colorscheme gruvbox/
		     s/background=light/background=dark/
			 " -i $NVIM
	end
	echo "Nvim configured."
end # }}}

function change_rofi # {{{
	cp $ROFI $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "16,19 s/28/fa/g
		     16,19 s/ebdbb2/5c6773/g
			 " -i $ROFI
	else
		sed "16,19 s/fa/28/g
		     16,19 s/5c6773/ebdbb2/g
			 " -i $ROFI
	end
	echo "Rofi configured."
end # }}}

function change_ranger # {{{
	cp $RANGER $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "100 s/default/solarized/
			 " -i $RANGER
	else
		sed "100 s/solarized/default/
			 " -i $RANGER
	end
	echo "Ranger configured."
end # }}}

function change_spicetify # {{{
	cp $SPICETIFY $BACKUP
	if test $COLORSCHEME = "ayu"
		sed "5 s/dracula/white/
			 " -i $SPICETIFY
	else
		sed "5 s/white/dracula/
			 " -i $SPICETIFY
	end
	echo "Spicetify configured."
	spicetify apply -n
end # }}}

function change_zathura # {{{
	if test $COLORSCHEME = "ayu"
		sed "107,146 s/^#//
			 65,104 s/^/#/
			 " -i $ZATHURA
	else
		sed "107,146 s/^/#/
			 65,104 s/^#//
			 " -i $ZATHURA
	end

	echo "Zathura configured."
end # }}}

change_polybar
change_qutebrowser
change_term
change_zathura
change_background
change_nvim
change_rofi
change_ranger
change_spicetify
