if exists('b:current_syntax')
	finish
endif

hi ColorNum ctermfg=4 guifg=#0087ff
hi Color2 ctermfg=12 guifg=#00ffff
hi Color4 ctermfg=13 guifg=#af5fff
hi Color8 ctermfg=9 guifg=#ff5f00
hi Color16 ctermfg=11 guifg=#ffd700
hi Color32 ctermfg=10 guifg=#afd700
hi Color64 ctermfg=6 guifg=#008080
hi Color128 ctermfg=5 guifg=#8700ff
hi Color256 ctermfg=1 guifg=#ff0000
hi Color512 ctermfg=3 guifg=#ffaf00
hi Color1024 ctermfg=2 guifg=#008000

syntax match ColorNum '\s\d\+\(.\|\)\s'
syntax match Color2 '\s2\s'
syntax match Color4 '\s4\s'
syntax match Color8 '\s8\s'
syntax match Color16 '\s16\s'
syntax match Color32 '\s32\s'
syntax match Color64 '\s64\s'
syntax match Color128 '\s128\s'
syntax match Color256 '\s256\s'
syntax match Color512 '\s512\s'
syntax match Color1024 '\s1024\s'

let b:current_syntax = '2048'
