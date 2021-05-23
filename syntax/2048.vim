if exists('b:current_syntax')
	finish
endif

hi ColorNum ctermfg=4
hi Color2 ctermfg=12
hi Color4 ctermfg=13
hi Color8 ctermfg=9
hi Color16 ctermfg=11
hi Color32 ctermfg=10
hi Color64 ctermfg=6
hi Color128 ctermfg=5
hi Color256 ctermfg=1
hi Color512 ctermfg=3
hi Color1024 ctermfg=2

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
